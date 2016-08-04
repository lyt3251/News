//
//  BaseViewController.m
//  TXChatDemo
//
//  Created by Cloud on 15/6/1.
//  Copyright (c) 2015年 IST. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MMPopupView.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import "Comment.h"
#import "Masonry.h"
#import "UILabel+ContentSize.h"
#import "UIView+Utils.h"
#import "TXImagePickerController.h"
#import "MBProgressHUD.h"
#import "TXCustomAlertWindow.h"
#import "UIView+AlertView.h"
#import "TXAsynRun.h"
#import "TXDatePopView.h"
#import "TXSharePopView.h"
#import "ShareModelHelper.h"
#import "ShareActionModel.h"
#import "ShareActionManager.h"


@interface BaseViewController () <TXImagePickerControllerDelegate>
{
    UIView *_connectView;           //网络状态视图
    UIImageView *_noDataImage;//无数据时显示的默认图
    UILabel *_noDataLabel;//无数据时显示的默认提示语
}

@end

@implementation BaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init{
    self = [super init];
    if (self) {
        _navigationBarViewType = NavigationBarTitleViewType;
        _shouldLimitTitleLabelWidth = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    //更新旋转配置
//    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
//    sheetConfig.enableDeviceOrientation = _enableSheetOrientation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBackground;
    // Do any additional setup after loading the view.
    [self commonSetup];
    //设置Sheet配置
    [self setupSheetConfigure];
    //禁止滑动返回
//    NSString *gesturePopValue = [UMOnlineConfig getConfigParams:@"gesturePop"];
//    if (gesturePopValue) {
//        self.fd_interactivePopDisabled = [gesturePopValue boolValue];
//    }
}
- (void)commonSetup
{
    //取消iOS7上的insetEdge
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
//标题
- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    _titleLb.text = _titleStr;
}

- (void)createCustomNavBar{
    CGFloat navHeight = IOS7_OR_LATER?kNavigationHeight + kStatusBarHeight:kNavigationHeight;
    self.customNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight)];
    _customNavigationView.backgroundColor = kColorNavigationBackGroundColor;
    _customNavigationView.userInteractionEnabled = YES;
//    _customNavigationView.clipsToBounds = YES;
    [self.view addSubview:_customNavigationView];
    
    CGFloat segmentWidth = 100;
    
    // 左按钮
    _btnLeft = [[CustomButton alloc] initWithFrame:CGRectMake(0, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight)];
    _btnLeft.showBackArrow = YES;
    _btnLeft.tag = TopBarButtonLeft;
    _btnLeft.adjustsImageWhenHighlighted = NO;
    _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnLeft.titleLabel.font = kFontMiddle;
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, kEdgeInsetsLeft - 4, 0, 0);
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, kEdgeInsetsLeft, 0, 0);
    _btnLeft.exclusiveTouch = YES;
    //[_btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"nav_icon_back_nor"] forState:UIControlStateNormal];
    [_btnLeft setImage:[UIImage imageNamed:@"nav_icon_back_sel"] forState:UIControlStateSelected];
    [_btnLeft addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitleColor:kColorNavigationTitle forState:UIControlStateNormal];
    [_btnLeft setTitleColor:kColorNavigationTitle forState:UIControlStateDisabled];
    // 右按钮
    _btnRight = [[CustomButton alloc] initWithFrame:CGRectMake(_customNavigationView.width_ - segmentWidth, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight)];
    _btnRight.showBackArrow = NO;
    _btnRight.tag = TopBarButtonRight;
    _btnRight.adjustsImageWhenHighlighted = NO;
    _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnRight.titleLabel.font = kFontMiddle;
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kEdgeInsetsLeft);
    _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kEdgeInsetsLeft);
    _btnRight.exclusiveTouch = YES;
    [_btnRight addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setTitleColor:kColorNavigationTitle forState:UIControlStateNormal];
    [_btnRight setTitleColor:kColorNavigationTitle forState:UIControlStateDisabled];
    
    _titleLb = [[UILabel alloc] initClearColorWithFrame:CGRectMake(0, 0, _customNavigationView.width_ - _btnLeft.width_ - _btnRight.width_, kNavigationHeight)];
    _titleLb.frame = CGRectMake(0, 0,_shouldLimitTitleLabelWidth ? _customNavigationView.width_ - _btnLeft.width_ - _btnRight.width_ : _customNavigationView.width_, kNavigationHeight);
    _titleLb.center = CGPointMake(_customNavigationView.center.x, _customNavigationView.height_ - kNavigationHeight / 2);
    _titleLb.font = kFontSuperLarge_b;
    _titleLb.textColor = kColorNavigationTitle;
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [_customNavigationView addSubview:_titleLb];
    [_customNavigationView addSubview:_btnLeft];
    [_customNavigationView addSubview:_btnRight];
    //添加分割线
    self.barLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _customNavigationView.maxY - 0.5, _customNavigationView.width_, 0.5)];
    _barLineView.backgroundColor = RGBCOLOR(0xd8, 0xd8, 0xd8);
    [_customNavigationView addSubview:_barLineView];
    //设置内容
    _titleLb.text = _titleStr;
}
- (void)setupDarkModeNavigationBar
{
    self.view.backgroundColor = RGBCOLOR(3, 3, 3);
    CGFloat navHeight = IOS7_OR_LATER?kNavigationHeight + kStatusBarHeight:kNavigationHeight;
    self.customNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight)];
    _customNavigationView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    _customNavigationView.userInteractionEnabled = YES;
    //    _customNavigationView.clipsToBounds = YES;
//    _customNavigationView.hidden = YES;
    [self.view addSubview:_customNavigationView];
    
    CGFloat segmentWidth = 100;
    
    // 左按钮
    _btnLeft = [[CustomButton alloc] initWithFrame:CGRectMake(0, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight)];
    _btnLeft.showBackArrow = NO;
    _btnLeft.tag = TopBarButtonLeft;
    _btnLeft.adjustsImageWhenHighlighted = NO;
    _btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnLeft.titleLabel.font = kFontMiddle;
    _btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, kEdgeInsetsLeft + 5, 0, 0);
    _btnLeft.imageEdgeInsets = UIEdgeInsetsMake(0, kEdgeInsetsLeft, 0, 0);
    _btnLeft.exclusiveTouch = YES;
    [_btnLeft setTitle:@"取消" forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_btnLeft setTitleColor:kColorGray forState:UIControlStateDisabled];
    // 右按钮
    _btnRight = [[CustomButton alloc] initWithFrame:CGRectMake(_customNavigationView.width_ - segmentWidth, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight)];
    _btnRight.showBackArrow = NO;
    _btnRight.tag = TopBarButtonRight;
    _btnRight.adjustsImageWhenHighlighted = NO;
    _btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _btnRight.titleLabel.font = kFontMiddle;
    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kEdgeInsetsLeft);
    _btnRight.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kEdgeInsetsLeft);
    _btnRight.exclusiveTouch = YES;
    [_btnRight addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_btnRight setTitleColor:kColorGray forState:UIControlStateDisabled];
    
    _titleLb = [[UILabel alloc] initClearColorWithFrame:CGRectMake(0, 0, _customNavigationView.width_ - _btnLeft.width_ - _btnRight.width_, kNavigationHeight)];
    _titleLb.frame = CGRectMake(0, 0,_shouldLimitTitleLabelWidth ? _customNavigationView.width_ - _btnLeft.width_ - _btnRight.width_ : _customNavigationView.width_, kNavigationHeight);
    _titleLb.center = CGPointMake(_customNavigationView.center.x, _customNavigationView.height_ - kNavigationHeight / 2);
    _titleLb.font = kFontMiddle;
    _titleLb.textColor = kColorWhite;
    _titleLb.textAlignment = NSTextAlignmentCenter;
    [_customNavigationView addSubview:_titleLb];
    [_customNavigationView addSubview:_btnLeft];
    [_customNavigationView addSubview:_btnRight];
    //设置内容
    _titleLb.text = _titleStr;
}
- (void)onClickBtn:(UIButton *)sender{
    if (sender.tag == TopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//更新竖屏布局
- (void)updateNavigationBarLayoutToPortrait
{
    CGFloat segmentWidth = 100;
    _btnLeft.frame = CGRectMake(0, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight);
    _btnRight.frame = CGRectMake(_customNavigationView.width_ - segmentWidth, _customNavigationView.height_ - kNavigationHeight, segmentWidth, kNavigationHeight);
    _titleLb.frame = CGRectMake(60, kStatusBarHeight,_customNavigationView.width_ - 120, kNavigationHeight);
    _barLineView.frame = CGRectMake(0, _customNavigationView.maxY - kLineHeight, _customNavigationView.width_, kLineHeight);
}
//更新横屏布局
- (void)updateNavigationBarLayoutToLandscape
{
    CGFloat segmentWidth = 100;
    _btnLeft.frame = CGRectMake(0, 0, segmentWidth, kNavigationHeight);
    _btnRight.frame = CGRectMake(_customNavigationView.height_ - segmentWidth, 0, segmentWidth, kNavigationHeight);
    _titleLb.frame = CGRectMake(60, 0,_customNavigationView.height_ - 120, kNavigationHeight);
    _barLineView.frame = CGRectMake(0, kNavigationHeight - kLineHeight, _customNavigationView.height_, kLineHeight);
}
//#pragma mark - 毛玻璃模糊效果
///**
// *  添加毛玻璃模糊效果到view上
// *
// *  @param view 需要添加毛玻璃效果的view
// */
//- (void)addVisualEffectToView:(UIView *)view
//{
//    if (IOS8AFTER) {
//        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        visualEffectView.frame = view.bounds;
//        [view addSubview:visualEffectView];
//        [view addSubview:visualEffectView];
//    }else{
//        TXTranslucentView *translucentView = [[TXTranslucentView alloc] initWithFrame:view.bounds];
//        translucentView.translucentAlpha = 1;
//        translucentView.translucentStyle = UIBarStyleBlack;
//        translucentView.translucentTintColor = [UIColor clearColor];
//        translucentView.backgroundColor = [UIColor clearColor];
//        [view addSubview:translucentView];
//    }
//}
//#pragma mark - 分享
//- (void)shareToSocialWithLink:(NSString *)linkURLString
//                        title:(NSString *)linkTitle
//{
//    if (!linkURLString && ![linkURLString length]) {
//        return;
//    }
//    //添加复制链接
//    UMSocialSnsPlatform *snsPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"CopyLink"];
//    snsPlatform.displayName = @"复制链接";
//    snsPlatform.bigImageName = @"share_icon_copy";
//    snsPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
//        BaseViewController *detailVc = (BaseViewController *)presentingController;
//        if (detailVc) {
//            //            NSLog(@"链接地址：%@",detailVc->_article.articleUrlString);
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            [pasteboard setString:linkURLString];
//            //添加HUD效果
//            [detailVc showSuccessHudWithTitle:@"复制链接成功"];
//        }
//    };
//    [UMSocialConfig addSocialSnsPlatform:@[snsPlatform]];
//    //设置你要在分享面板中出现的平台
//    [UMSocialConfig setSnsPlatformNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,@"CopyLink"]];
//    //分享
//    NSString *title = linkTitle ?: @"";
//    NSString *URL   = linkURLString;
//    // 微信相关设置
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = URL;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = URL;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
//    //    [UMSocialData defaultData].extConfig.title = self.titleStr;
//    
//    // 手机QQ相关设置
//    [UMSocialQQHandler setQQWithAppId:UMENG_QQAppId appKey:UMENG_QQAppKey url:URL];
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//    [UMSocialData defaultData].extConfig.qqData.title = title;
//    [UMSocialData defaultData].extConfig.qqData.url = URL;
//    
//    // 复制链接
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMENG_APPKEY
//                                      shareText:title
//                                     shareImage:[UIImage imageNamed:@"appLogo"]
//                                shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQQ,@"CopyLink"]
//                                       delegate:nil];
//    
//}
//- (void)shareToSocialWithImage:(UIImage *)image
//{
//    if (!image) {
//        return;
//    }
//    //设置你要在分享面板中出现的平台
//    [UMSocialConfig setSnsPlatformNames:@[UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ]];
//    // 微信相关设置
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//    // 手机QQ相关设置
//    [UMSocialQQHandler setQQWithAppId:UMENG_QQAppId appKey:UMENG_QQAppKey url:@""];
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
//    [UMSocialData defaultData].extConfig.qqData.title = @"";
//    // 复制链接
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMENG_APPKEY
//                                      shareText:nil
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQQ]
//                                       delegate:nil];
//    
//}
#pragma mark - 底部弹出框Sheet
- (void)setEnableSheetOrientation:(BOOL)enableSheetOrientation
{
    _enableSheetOrientation = enableSheetOrientation;
//    //更新配置
//    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
//    sheetConfig.enableDeviceOrientation = _enableSheetOrientation;
}
- (void)setupSheetConfigure
{
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMSheetViewConfig *sheetConfig = [MMSheetViewConfig globalConfig];
    sheetConfig.splitColor = RGBCOLOR(236, 237, 239);
    sheetConfig.itemNormalColor = RGBCOLOR(0x44, 0x44, 0x44);
    sheetConfig.defaultTextCancel = @"取消";
}
//弹出普通的Sheet框
- (void)showNormalSheetWithTitle:(NSString *)title
                           items:(NSArray *)items
                    clickHandler:(void(^)(NSInteger index))handler
                      completion:(void(^)(void))completion
{
    //    MMPopupItemHandler block = ^(NSInteger index){
    //        NSLog(@"clickd %@ button",@(index));
    //    };
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        if (completion) {
            completion();
        }
    };
    NSMutableArray *popItems = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        MMPopupItem *item = MMItemMake(obj, MMItemTypeNormal, handler);
        [popItems addObject:item];
    }];
    //弹出视图
    [[[MMSheetView alloc] initWithTitle:title
                                  items:popItems] showWithBlock:completeBlock];
}
//弹出带高亮的Sheet框
- (void)showHighlightedSheetWithTitle:(NSString *)title
                          normalItems:(NSArray *)normalItems
                     highlightedItems:(NSArray *)highlightedItems
                           otherItems:(NSArray *)otherItems
                         clickHandler:(void(^)(NSInteger index))handler
                           completion:(void(^)(void))completion
{
//    MMPopupItemHandler block = ^(NSInteger index){
//        NSLog(@"clickd %@ button",@(index));
//    };
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
        if (completion) {
            completion();
        }
    };
    NSMutableArray *popItems = [NSMutableArray array];
    [normalItems enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        MMPopupItem *item = MMItemMake(obj, MMItemTypeNormal, handler);
        [popItems addObject:item];
    }];
    [highlightedItems enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        MMPopupItem *item = MMItemMake(obj, MMItemTypeHighlight, handler);
        [popItems addObject:item];
    }];
    [otherItems enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        MMPopupItem *item = MMItemMake(obj, MMItemTypeNormal, handler);
        [popItems addObject:item];
    }];
    //弹出视图
    [[[MMSheetView alloc] initWithTitle:title
                                  items:popItems] showWithBlock:completeBlock];
}
//弹出日期选择框
- (void)showDatePickerWithCurrentDate:(NSDate *)currentDate
                          minimumDate:(NSDate *)minimumDate
                          maximumDate:(NSDate *)maximumDate
                         selectedDate:(NSDate *)selectedDate
                        selectedBlock:(void(^)(NSDate *selectedDate))selectedBlcok
{
    TXDatePopView *dateView = [TXDatePopView new];
    [dateView setPickerCurrentDate:currentDate minimumDate:minimumDate maximumDate:maximumDate selectedDate:selectedDate selectedBlock:selectedBlcok];
    [dateView showWithBlock:nil];
}
#pragma mark - 图片选择组件
//弹出图片选择器
- (void)showImagePickerController
{
    [self showImagePickerControllerWithCurrentSelectedCount:0];
}
//根据当前已选择的数量弹出图片选择器
- (void)showImagePickerControllerWithCurrentSelectedCount:(NSInteger)count
{
    [self showImagePickerControllerWithMaxSelectionNumber:9 currentSelectedCount:count];
}
//根据当前已选择的数量和最大数量弹出图片选择器
- (void)showImagePickerControllerWithMaxSelectionNumber:(NSInteger)maxCount
                                   currentSelectedCount:(NSInteger)currentCount
{
    [self showImagePickerControllerMaxSelectionNumber:maxCount currentSelectedCount:currentCount animation:YES completion:nil];
}
//根据各个属性弹出图片选择器
- (void)showImagePickerControllerMaxSelectionNumber:(NSInteger)maxCount
                               currentSelectedCount:(NSInteger)currentCount
                                          animation:(BOOL)flag
                                         completion:(void(^)(void))completion
{
    TXImagePickerController *imagePicker = [[TXImagePickerController alloc] init];
    imagePicker.maxSelectionNumber = maxCount;
    imagePicker.currentSelectedCount = currentCount;
    imagePicker.delegate = self;
    [imagePicker showImagePickerBy:self animated:flag completion:completion];
}
//隐藏HUD视图
- (void)hideImagePickerControllerHUD:(TXImagePickerController *)picker
{
    UIView *contentView = [picker currentViewContent];
    [MBProgressHUD hideHUDForView:contentView animated:YES];
}
//弹出超过图片最大选择数的提示HUD
- (void)showReachImageMaxSelectionTipHUD:(TXImagePickerController *)picker
{
    UIView *contentView = [picker currentViewContent];
    MBProgressHUD *failedHud = [[MBProgressHUD alloc] initWithView:contentView];
    failedHud.mode = MBProgressHUDModeText;
    failedHud.labelText = [NSString stringWithFormat:@"最多只能选择%@张图片",@(picker.maxSelectionNumber)];
    [contentView addSubview:failedHud];
    [failedHud show:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [failedHud hide:YES];
    });
}
//选取图片结束
- (void)didFinishImagePicker:(TXImagePickerController *)picker
{
    [self hideImagePickerControllerHUD:picker];
    [picker dismissImagePickerControllerWithAnimated:YES];
}
#pragma mark - TXImagePickerControllerDelegate
- (void)imagePickerControllerStartProcessingImages:(TXImagePickerController *)picker
{
    UIView *contentView = [picker currentViewContent];
    [MBProgressHUD showHUDAddedTo:contentView animated:YES];
}
- (void)imagePickerController:(TXImagePickerController *)picker didFinishPickingImages:(NSArray<NSData *> *)imageArray
{
    [self didFinishImagePicker:picker];
}
- (void)imagePickerControllerDidCancelled:(TXImagePickerController *)picker
{
    [self didFinishImagePicker:picker];
}
- (void)imagePickerControllerReachMaxSelectNumber:(TXImagePickerController *)picker
{
    [self showReachImageMaxSelectionTipHUD:picker];
}
#pragma mark - 权限弹窗
//显示权限弹窗
- (void)showPermissionAlertWithCameraGranted:(BOOL)isGrantCamera
                           microphoneGranted:(BOOL)isGrantMacrophone
{
    ButtonItem *setItem = [ButtonItem itemWithLabel:@"去设置" andTextColor:kColorBlack action:^{
        TXAsyncRunInMain(^{
            if(__IOS8)
            {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            }
        });
    }];
    NSString *alertTitle;
    if (!isGrantCamera && !isGrantMacrophone) {
        alertTitle = @"没有权限访问您的相机和麦克风,请到“设置-隐私-相机/麦克风”里把“微家园”的开关打开即可";
    }else if (isGrantCamera && !isGrantMacrophone) {
        alertTitle = @"没有权限访问您的麦克风,请到“设置-隐私-麦克风”里把“微家园”的开关打开即可";
    }else if (isGrantMacrophone && !isGrantCamera) {
        alertTitle = @"没有权限访问您的相机,请到“设置-隐私-相机”里把“微家园”的开关打开即可";
    }
    [self showAlertViewWithMessage:alertTitle andButtonItems:setItem, nil];
}
//显示相册权限弹窗
- (void)showPhotoPermissionDeniedAlert
{
    
    ButtonItem *setItem = [ButtonItem itemWithLabel:@"去设置" andTextColor:kColorBlack action:^{
        TXAsyncRunInMain(^{
            
            if(__IOS8)
            {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            }
        });
    }];
    NSString *alertTitle = @"没有权限访问您的照片,请到“设置-隐私-照片”里把“微家园”的开关打开";
    [self showAlertViewWithMessage:alertTitle andButtonItems:setItem, nil];
}
#pragma mark - Toast弹窗
- (void)showHudWithTitle:(NSString *)title
             orientation:(UIDeviceOrientation)orientation
{
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        //动画
        MBProgressHUD *finishHud = [[MBProgressHUD alloc] initWithView:self.view];
        CGAffineTransform transform;
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        [finishHud setTransform:transform];
        [[TXCustomAlertWindow sharedWindow] showWithView:finishHud];
        finishHud.mode = MBProgressHUDModeText;
        finishHud.labelText = title;
        
        [finishHud show:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [finishHud hide:YES];
            [[TXCustomAlertWindow sharedWindow] hide];
        });
    }else{
        [self showSuccessHudWithTitle:title];
    }
}
- (void)showSuccessHudWithTitle:(NSString *)title
{
    [self showSuccessHudWithTitle:title showSuccessImage:NO];
}
- (void)showSuccessHudWithTitle:(NSString *)title
               showSuccessImage:(BOOL)showSuccessImage
{
    //动画
    MBProgressHUD *finishHud = [[MBProgressHUD alloc] initWithView:self.view];
//    finishHud.layer.cornerRadius = 5.f;
//    finishHud.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
//    [self.view addSubview:finishHud];
    [[TXCustomAlertWindow sharedWindow] showWithView:finishHud];
    
    if (showSuccessImage) {
        finishHud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_complete"]];
        finishHud.customView = imageView;
    }else{
        finishHud.mode = MBProgressHUDModeText;
    }
    
    //    finishHud.delegate = self;
    finishHud.labelText = title;
    
    [finishHud show:YES];
//    [finishHud hide:YES afterDelay:1.5f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [finishHud hide:YES];
        [[TXCustomAlertWindow sharedWindow] hide];
    });
}
//展示失败动画
- (void)showFailedHudWithError:(NSError *)error
{
    NSString *message = error.userInfo[kErrorMessage];
    NSString *msgWithCode = nil;
    if(error.code > 0)
    {
        msgWithCode = [NSString stringWithFormat:@"%@(%@)",message, @(error.code)];
    }
    else
    {
        msgWithCode = message;
    }
    [self showFailedHudWithTitle:msgWithCode showSuccessImage:NO];
}
- (void)showFailedHudWithTitle:(NSString *)title
{
    [self showFailedHudWithTitle:title showSuccessImage:NO];
}
//展示失败动画
- (void)showFailedHudWithTitle:(NSString *)title
              showSuccessImage:(BOOL)showSuccessImage
{
    MBProgressHUD *failedHud = [[MBProgressHUD alloc] initWithView:self.view];
//    failedHud.layer.cornerRadius = 5.f;
//    failedHud.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
//    [self.view addSubview:failedHud];
    [[TXCustomAlertWindow sharedWindow] showWithView:failedHud];
    
    //    finishHud.customView = customView;
    if (showSuccessImage) {
        failedHud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failed"]];
        failedHud.customView = imageView;
    }else{
        failedHud.mode = MBProgressHUDModeText;
    }
    
    //    finishHud.delegate = self;
    failedHud.labelText = title;
    
    [failedHud show:YES];
//    [failedHud hide:YES afterDelay:1.5f];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [failedHud hide:YES];
        [[TXCustomAlertWindow sharedWindow] hide];
    });
}

#pragma mark - Alert弹窗
- (void)showAlertViewWithMessage:(NSString *)message andButtonItems:(ButtonItem *)buttonItem, ...{
    va_list args;
    va_start(args, buttonItem);
    
    NSMutableArray *buttonsArray = [NSMutableArray array];
    if(buttonItem)
    {
        [buttonsArray addObject:buttonItem];
        ButtonItem *nextItem;
        while((nextItem = va_arg(args, ButtonItem *)))
        {
            [buttonsArray addObject:nextItem];
        }
    }
    va_end(args);
    [self.view showAlertViewWithMessage:message andButtonItemsArr:buttonsArray];
}

- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonItems:(ButtonItem *)buttonItem, ...{
    va_list args;
    va_start(args, buttonItem);
    
    NSMutableArray *buttonsArray = [NSMutableArray array];
    if(buttonItem)
    {
        [buttonsArray addObject:buttonItem];
        ButtonItem *nextItem;
        while((nextItem = va_arg(args, ButtonItem *)))
        {
            [buttonsArray addObject:nextItem];
        }
    }
    va_end(args);
    [self.view showAlertViewWithTitle:title andMessage:message andButtonItemsArr:buttonsArray];
}

//屏蔽特定error的弹窗
- (void)showAlertViewWithError:(NSError *)error andButtonItems:(ButtonItem *)buttonItem, ...{
    va_list args;
    va_start(args, buttonItem);
    
    NSMutableArray *buttonsArray = [NSMutableArray array];
    if(buttonItem)
    {
        [buttonsArray addObject:buttonItem];
        ButtonItem *nextItem;
        while((nextItem = va_arg(args, ButtonItem *)))
        {
            [buttonsArray addObject:nextItem];
        }
    }
    va_end(args);
    [self.view showAlertViewWithError:error andButtonItemsArr:buttonsArray];
}
#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark-- share

/**
 *  分享链接
 *
 *  @param shareUrl    分享链接
 *  @param titleStr    分享标题
 *  @param subTitleStr 分享副标题
 */
-(void)shareUrlByLinkUrl:(NSString *)linkURLString title:(NSString *)title detailTitle:(NSString *)detailTitle localImage:(UIImage *)localImage
{
    NSMutableArray *array = [NSMutableArray array];
#if (TARGET_IPHONE_SIMULATOR)
    
    [array addObject:@(TXShareType_WechatTimeline)];
    [array addObject:@(TXShareType_WechatSession)];
    [array addObject:@(TXShareType_QQ)];
#else
    NSArray *array1 = [[ShareModelHelper sharedInstance] getSharePlatformTypeAndIsComeInternal:NO];
    for(int i=0;i<array1.count;i++){
        NSNumber *num = [array1 objectAtIndex:i];
        NSInteger a = [num integerValue];
        if (a==kSharePlatformWXSceneSession) {
            [array addObject:@(TXShareType_WechatTimeline)];
            [array addObject:@(TXShareType_WechatSession)];
        }
        //        else if (a==kShareCopyLink){
        //            if (isLinkCopyable==YES) {
        //                [array addObject:@(TXShareType_CopyLink)];
        //            }
        //        }
        else if(a==kSharePlatformQQFriends)
        {
            [array addObject:@(TXShareType_QQ)];
        }
    }
#endif
    
    [self showShareSheetWithTypes:array clickBlock:^(TXShareType type) {
        NSLog(@"点击了第%ld个按钮",type);
        [self shareWithLink:linkURLString
                      title:title
                    content:detailTitle
                   imageURL:nil
                 localImage:localImage
                       type:type];
    }];
    return;
}

//弹出分享视图
- (void)showShareSheetWithTypes:(NSArray<NSNumber *> *)shareTypes
                     clickBlock:(void(^)(TXShareType type))clickBlock
{
    if (!shareTypes || ![shareTypes count]) {
        return;
    }
    TXSharePopView *popView = [TXSharePopView new];
    [popView setupSharePopViewWithTypes:shareTypes clickBlock:clickBlock];
    [popView showWithBlock:nil];
}

- (void)shareWithLink:(NSString *)urlString
                title:(NSString *)title
              content:(NSString *)content
             imageURL:(NSString *)imageURL
           localImage:(UIImage *)localImage
                 type:(TXShareType)type
{
    ShareActionModel *model = [[ShareActionModel alloc] init];
    model.shareUrl = urlString;
    model.wxImageUrl = imageURL;
    model.titleStr = title;
    model.commentStr = content;
    model.shareImageUrl = imageURL;
    model.imageLocal = localImage;
    if (type == TXShareType_WechatTimeline) {
        //朋友圈
        [[ShareActionManager shareInstance] htmlShareToPlatformType:kSharePlatformWXSceneTimeline FromViewController:self andPostShareModel:model];
    }else if (type == TXShareType_WechatSession) {
        //微信好友
        [[ShareActionManager shareInstance] htmlShareToPlatformType:kSharePlatformWXSceneSession FromViewController:self andPostShareModel:model];
    }else if (type == TXShareType_QQ) {
        //QQ
        [[ShareActionManager shareInstance] htmlShareToPlatformType:kSharePlatformQQFriends FromViewController:self andPostShareModel:model];
    }else if (type == TXShareType_CopyLink) {
        //复制链接
        [[ShareActionManager shareInstance] htmlShareToPlatformType:kShareCopyLink FromViewController:self andPostShareModel:model];
    }
}
@end

@implementation CustomButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (self.showBackArrow) {
        [self setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    }else{
        [self setImage:nil forState:UIControlStateNormal];
    }
    [super setTitle:title forState:state];
}




@end



