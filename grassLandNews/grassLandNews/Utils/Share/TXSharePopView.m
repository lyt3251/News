//
//  TXSharePopView.m
//  TXChatParent
//
//  Created by 陈爱彬 on 16/7/12.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "TXSharePopView.h"
#import <MMPopupDefine.h>
#import <MMPopupCategory.h>
#import <MMSheetView.h>
#import <Masonry.h>

static NSInteger const kSharePopViewDefaultColumn = 4;
static NSInteger const kShareButtonTag = 100;

@interface TXSharePopView()
{
    UIView *_btnView;
    UIButton *_cancelButton;
}
//列数，默认为4
@property (nonatomic,assign) NSInteger column;
@property (nonatomic,strong) NSMutableArray *shareList;
@property (nonatomic,copy) TXSharePopViewClickBlock clickBlock;
@end

@implementation TXSharePopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = MMPopupTypeSheet;
//        self.backgroundColor = MMHexColor(0xe5e6e6FF);
        self.backgroundColor = [UIColor whiteColor];
        
        self.shareList = [[NSMutableArray alloc] init];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _btnView = [[UIView alloc] init];
        _btnView.backgroundColor = [UIColor clearColor];
        _btnView.clipsToBounds = NO;
        [self addSubview:_btnView];

        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:kColorNewsRoll forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@30);
            make.right.mas_equalTo(@(-30));
            make.top.mas_equalTo(@30);
        }];
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@0);
            make.right.mas_equalTo(@0);
            make.height.mas_equalTo(@48);
            make.top.mas_equalTo(_btnView.mas_bottom ).with.offset(kLineHeight);
            make.bottom.mas_equalTo(self);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor =RGBCOLOR(0xea, 0xea, 0xea);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(_cancelButton.mas_top);
            make.height.mas_equalTo(kLineHeight);
        }];
        
        
        //更新屏幕旋转功能
//        MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
//        self.enableDeviceOrientation = sheetConfig.enableDeviceOrientation;
    }
    return self;
}
- (void)setupSharePopViewWithTypes:(NSArray<NSNumber *> *)types
                        clickBlock:(TXSharePopViewClickBlock)clickBlock
{
    [self setupSharePopViewWithTypes:types column:kSharePopViewDefaultColumn clickBlock:clickBlock];
}
- (void)setupSharePopViewWithTypes:(NSArray<NSNumber *> *)types
                            column:(NSInteger)column
                        clickBlock:(TXSharePopViewClickBlock)clickBlock
{
    _column = column;
    if (_column == 0) {
        //如果为0，默认是4列
        _column = kSharePopViewDefaultColumn;
    }
    self.clickBlock = clickBlock;
    //封装数组
    _shareList = [NSMutableArray array];
    for (NSNumber *number in types) {
        TXShareType type = [number integerValue];
        TXShareData *data = [[TXShareConfig sharedConfig] dataForType:type];
        [_shareList addObject:data];
    }
    //更新界面
    [self updateViews];
}
- (void)updateViews
{
    if (!_shareList) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnWidth = (width - 60 - (_column - 1) * 25) / 4.f;
    __block CGFloat offsetX = 0;
    __block UIView *lastView = nil;
    NSInteger rowCount = (NSInteger)(ceilf([_shareList count] / (CGFloat)_column));
    for (NSInteger i = 0; i < [_shareList count]; i++) {
        NSInteger currentRow = i / _column;
        //添加视图
        TXShareData *data = _shareList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor whiteColor];
//        btn.layer.cornerRadius = 14.f;
//        btn.layer.masksToBounds = YES;
        btn.tag = kShareButtonTag + i;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:data.shareImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onShareButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:btn];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = kColorNewsRoll;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = data.name;
        [_btnView addSubview:label];
        //布局
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(btnWidth);
            make.height.mas_equalTo(btnWidth);
            make.left.mas_equalTo(offsetX);
            if (lastView) {
                BOOL isFirstRow = currentRow == 0;
                make.top.mas_equalTo(lastView.mas_bottom).offset(isFirstRow ? 0 : 14);
            }else{
                make.top.mas_equalTo(0);
            }
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn);
            make.top.mas_equalTo(btn.mas_bottom).offset(10);
            if (i == [_shareList count] - 1) {
                make.bottom.mas_equalTo(_btnView.mas_bottom).offset(-30);
            }
        }];
        //添加分割线
        if ((i + 1) % _column == 0) {
            //设置lastView
            lastView = label;
            if ((currentRow + 1)!= rowCount) {
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = MMHexColor(0xc4c4c4FF);
                [_btnView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(30);
                    make.height.mas_equalTo(0.5);
                    make.top.mas_equalTo(lastView.mas_bottom).offset(29);
                }];
                //设置lastView
                lastView = lineView;
            }
        }
        //更新偏移量
        if ((i + 1) % _column == 0) {
            offsetX = 0;
        }else{
            offsetX += (btnWidth + 25);
        }
    }
}
- (void)onShareButtonTapped:(UIButton *)btn
{
    NSInteger index = btn.tag - kShareButtonTag;
    TXShareData *data = _shareList[index];
    if (self.clickBlock) {
        self.clickBlock(data.type);
    }
    [self hide];
}
- (void)onCancelButtonTapped
{
    [self hide];
}
@end

#pragma mark - TXShareData
@implementation TXShareData

@end

#pragma mark - TXShareConfig
@implementation TXShareConfig

+ (instancetype)sharedConfig
{
    static TXShareConfig *_sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [[TXShareConfig alloc] init];
    });
    return _sharedConfig;
}
//微信朋友圈
- (TXShareData *)wechatTimelineData
{
    if (!_wechatTimelineData) {
        _wechatTimelineData = [[TXShareData alloc] init];
        _wechatTimelineData.name = @"朋友圈";
        _wechatTimelineData.type = TXShareType_WechatTimeline;
        _wechatTimelineData.shareImage = [UIImage imageNamed:@"share_wechatTimeline"];
    }
    return _wechatTimelineData;
}
//微信好友
- (TXShareData *)wechatSessionData
{
    if (!_wechatSessionData) {
        _wechatSessionData = [[TXShareData alloc] init];
        _wechatSessionData.name = @"微信好友";
        _wechatSessionData.type = TXShareType_WechatSession;
        _wechatSessionData.shareImage = [UIImage imageNamed:@"share_wechatSession"];
    }
    return _wechatSessionData;
}
//QQ好友
- (TXShareData *)qqData
{
    if (!_qqData) {
        _qqData = [[TXShareData alloc] init];
        _qqData.name = @"QQ好友";
        _qqData.type = TXShareType_QQ;
        _qqData.shareImage = [UIImage imageNamed:@"share_qqData"];
    }
    return _qqData;
}

//QQ好友
- (TXShareData *)sinaWeiBoData
{
    if (!_sinaWeiBoData) {
        _sinaWeiBoData = [[TXShareData alloc] init];
        _sinaWeiBoData.name = @"新浪微博";
        _sinaWeiBoData.type = TXShareType_SinaWeiBo;
        _sinaWeiBoData.shareImage = [UIImage imageNamed:@"share_sinaWeiBo"];
    }
    return _sinaWeiBoData;
}

//复制链接
- (TXShareData *)linkCopyData
{
    if (!_linkCopyData) {
        _linkCopyData = [[TXShareData alloc] init];
        _linkCopyData.name = @"复制链接";
        _linkCopyData.type = TXShareType_CopyLink;
        _linkCopyData.shareImage = [UIImage imageNamed:@"share_copyLink"];
    }
    return _linkCopyData;
}
//浏览器打开
- (TXShareData *)openInSafariData
{
    if (!_openInSafariData) {
        _openInSafariData = [[TXShareData alloc] init];
        _openInSafariData.name = @"浏览器打开";
        _openInSafariData.type = TXShareType_OpenInSafari;
        _openInSafariData.shareImage = [UIImage imageNamed:@"share_openInSafari"];
    }
    return _openInSafariData;
}
//保存到手机
- (TXShareData *)saveData
{
    if (!_saveData) {
        _saveData = [[TXShareData alloc] init];
        _saveData.name = @"保存到手机";
        _saveData.type = TXShareType_Save;
        _saveData.shareImage = [UIImage imageNamed:@"share_saveToPhone"];
    }
    return _saveData;
}
//重新加载
- (TXShareData *)reloadData
{
    if (!_reloadData) {
        _reloadData = [[TXShareData alloc] init];
        _reloadData.name = @"重新加载";
        _reloadData.type = TXShareType_Reload;
        _reloadData.shareImage = [UIImage imageNamed:@"share_reload"];
    }
    return _reloadData;
}
//删除
- (TXShareData *)deleteData
{
    if (!_deleteData) {
        _deleteData = [[TXShareData alloc] init];
        _deleteData.name = @"删除";
        _deleteData.type = TXShareType_Delete;
        _deleteData.shareImage = [UIImage imageNamed:@"share_delete"];
    }
    return _deleteData;
}
//编辑
- (TXShareData *)editInfoData
{
    if (!_editInfoData) {
        _editInfoData = [[TXShareData alloc] init];
        _editInfoData.name = @"编辑";
        _editInfoData.type = TXShareType_Edit;
        _editInfoData.shareImage = [UIImage imageNamed:@"share_editInfo"];
    }
    return _editInfoData;
}
//根据类型获取data
- (TXShareData *)dataForType:(TXShareType)type
{
    switch (type) {
        case TXShareType_WechatTimeline: {
            return self.wechatTimelineData;
            break;
        }
        case TXShareType_WechatSession: {
            return self.wechatSessionData;
            break;
        }
        case TXShareType_QQ: {
            return self.qqData;
            break;
        }
        case TXShareType_CopyLink: {
            return self.linkCopyData;
            break;
        }
        case TXShareType_OpenInSafari: {
            return self.openInSafariData;
            break;
        }
        case TXShareType_Save: {
            return self.saveData;
            break;
        }
        case TXShareType_Reload: {
            return self.reloadData;
            break;
        }
        case TXShareType_Delete: {
            return self.deleteData;
            break;
        }
        case TXShareType_Edit: {
            return self.editInfoData;
            break;
        case TXShareType_SinaWeiBo:
            return self.sinaWeiBoData;
            break;
        }
    }
    return nil;
}
@end
