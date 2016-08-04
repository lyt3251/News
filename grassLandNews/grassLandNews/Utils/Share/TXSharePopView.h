//
//  TXSharePopView.h
//  TXChatParent
//
//  Created by 陈爱彬 on 16/7/12.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <MMPopupView.h>

typedef NS_ENUM(NSInteger, TXShareType) {
    TXShareType_WechatTimeline = 1,   //朋友圈
    TXShareType_WechatSession,        //微信好友
    TXShareType_QQ,                   //QQ
    TXShareType_CopyLink,             //复制链接
    TXShareType_OpenInSafari,         //在Safari中打开
    TXShareType_Save,                 //保存到手机
    TXShareType_Reload,               //重新加载
    TXShareType_Delete,               //删除
    TXShareType_Edit,                 //编辑
};

typedef void(^TXSharePopViewClickBlock)(TXShareType type);

@interface TXSharePopView : MMPopupView

- (void)setupSharePopViewWithTypes:(NSArray<NSNumber *> *)types
                        clickBlock:(TXSharePopViewClickBlock)clickBlock;

- (void)setupSharePopViewWithTypes:(NSArray<NSNumber *> *)types
                            column:(NSInteger)column
                        clickBlock:(TXSharePopViewClickBlock)clickBlock;

@end

@interface TXShareData : NSObject

/**
 *  标题名
 */
@property (nonatomic,copy) NSString *name;
/**
 *  类型
 */
@property (nonatomic,assign) TXShareType type;
/**
 *  图片
 */
@property (nonatomic,strong) UIImage *shareImage;

@end

/*配置类*/
@interface TXShareConfig : NSObject

//单例获取类
+ (instancetype)sharedConfig;

/**
 *  微信朋友圈信息配置
 */
@property (nonatomic,strong) TXShareData *wechatTimelineData;
/**
 *  微信好友信息配置
 */
@property (nonatomic,strong) TXShareData *wechatSessionData;
/**
 *  QQ信息配置
 */
@property (nonatomic,strong) TXShareData *qqData;
/**
 *  复制链接信息配置
 */
@property (nonatomic,strong) TXShareData *linkCopyData;
/**
 *  用Safari打开信息配置
 */
@property (nonatomic,strong) TXShareData *openInSafariData;
/**
 *  保存到手机信息配置
 */
@property (nonatomic,strong) TXShareData *saveData;
/**
 *  重新加载信息配置
 */
@property (nonatomic,strong) TXShareData *reloadData;
/**
 *  删除信息配置
 */
@property (nonatomic,strong) TXShareData *deleteData;
/**
 *  编辑信息配置
 */
@property (nonatomic,strong) TXShareData *editInfoData;

//根据类型获取data
- (TXShareData *)dataForType:(TXShareType)type;

@end
