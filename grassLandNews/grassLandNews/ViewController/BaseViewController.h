//
//  BaseViewController.h
//  TXChatDemo
//
//  Created by Cloud on 15/6/1.
//  Copyright (c) 2015年 IST. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXImagePickerController;

@interface CustomButton : UIButton

@property (nonatomic) BOOL showBackArrow;
@end

@class ButtonItem;

typedef enum {
    TopBarButtonLeft = 1,
    TopBarButtonRight = 2,
} NavBarButton;

typedef NS_ENUM(NSInteger, NavigationBarViewType) {
    NavigationBarTitleViewType,          //文字类型
    NavigationBarLoadingViewType,        //菊花转动类型
};

@interface BaseViewController : UIViewController

@property (nonatomic, strong) CustomButton *btnLeft;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) CustomButton *btnRight;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UIView *customNavigationView;
@property (nonatomic, strong) UIView *barLineView;
@property (nonatomic, assign) NavigationBarViewType navigationBarViewType;
@property (nonatomic, assign) BOOL shouldLimitTitleLabelWidth;

//是否是最顶的控制器
@property (nonatomic,assign) BOOL isTopVC;
//是否允许Sheet的屏幕旋转功能，默认为NO
@property (nonatomic,assign) BOOL enableSheetOrientation;

//创建自定义导航栏
- (void)createCustomNavBar;
//创建暗黑色调导航栏
- (void)setupDarkModeNavigationBar;

- (void)onClickBtn:(UIButton *)sender;
- (void)showAlertViewWithMessage:(NSString *)message andButtonItems:(ButtonItem *)buttonItem, ...NS_REQUIRES_NIL_TERMINATION;
//屏蔽特定error的弹窗
- (void)showAlertViewWithError:(NSError *)error andButtonItems:(ButtonItem *)buttonItem, ...NS_REQUIRES_NIL_TERMINATION;
- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message andButtonItems:(ButtonItem *)buttonItem, ...;

/**
 *  弹窗
 */
//根据屏幕方向显示Hud
- (void)showHudWithTitle:(NSString *)title
             orientation:(UIDeviceOrientation)orientation;
//成功弹窗
- (void)showSuccessHudWithTitle:(NSString *)title;

//失败弹窗
- (void)showFailedHudWithError:(NSError *)error;

//失败弹窗
- (void)showFailedHudWithTitle:(NSString *)title;


////更新隐藏显示状态
//-(void)updateEmptyDataImageStatus:(BOOL)isShow;

////更新隐藏显示状态 和显示提示语
//-(void)updateEmptyDataImageStatusAndTitle:(BOOL)isShow newShowTitle:(NSString *)title;

//显示权限弹窗
- (void)showPermissionAlertWithCameraGranted:(BOOL)isGrantCamera
                           microphoneGranted:(BOOL)isGrantMacrophone;

//显示相册权限弹窗
- (void)showPhotoPermissionDeniedAlert;

////点击图片后处理
//-(void)ImageViewTapEvent:(UITapGestureRecognizer*)recognizer;

//更新竖屏布局
- (void)updateNavigationBarLayoutToPortrait;
//更新横屏布局
- (void)updateNavigationBarLayoutToLandscape;

#pragma mark - 分享
//- (void)shareToSocialWithLink:(NSString *)linkURLString
//                        title:(NSString *)linkTitle;
//
//- (void)shareToSocialWithImage:(UIImage *)image;

#pragma mark - ActionSheet弹窗
/**
 *  弹出ActionSheet选择框
 *
 *  @param title      标题
 *  @param items      选择项，必须是NSString字符串集
 *  @param handler    点击响应block
 *  @param completion 动画完成的block
 */
- (void)showNormalSheetWithTitle:(NSString *)title
                           items:(NSArray *)items
                    clickHandler:(void(^)(NSInteger index))handler
                      completion:(void(^)(void))completion;

/**
 *  弹出带高亮的Sheet框
 *
 *  @param title            标题
 *  @param normalItems      普通的选择项，NSString集
 *  @param highlightedItems 高亮效果的选择项，NSString集
 *  @param otherItems       其他普通的选择性，NSString集
 *  @param handler          点击响应block
 *  @param completion       动画完成的block
 */
- (void)showHighlightedSheetWithTitle:(NSString *)title
                          normalItems:(NSArray *)normalItems
                     highlightedItems:(NSArray *)highlightedItems
                           otherItems:(NSArray *)otherItems
                         clickHandler:(void(^)(NSInteger index))handler
                           completion:(void(^)(void))completion;

/**
 *  弹出日期选择框
 *
 *  @param currentDate   当前时间
 *  @param minimumDate   最小时间
 *  @param maximumDate   最久时间
 *  @param selectedDate  当前选中的时间
 *  @param selectedBlcok 数据更改block
 */
- (void)showDatePickerWithCurrentDate:(NSDate *)currentDate
                          minimumDate:(NSDate *)minimumDate
                          maximumDate:(NSDate *)maximumDate
                         selectedDate:(NSDate *)selectedDate
                        selectedBlock:(void(^)(NSDate *selectedDate))selectedBlcok;

#pragma mark - 图片选择功能
//弹出图片选择器
- (void)showImagePickerController;

//根据当前已选择的数量弹出图片选择器
- (void)showImagePickerControllerWithCurrentSelectedCount:(NSInteger)count;

//根据当前已选择的数量和最大数量弹出图片选择器
- (void)showImagePickerControllerWithMaxSelectionNumber:(NSInteger)maxCount
                                   currentSelectedCount:(NSInteger)currentCount;

//根据各个属性弹出图片选择器
- (void)showImagePickerControllerMaxSelectionNumber:(NSInteger)maxCount
                               currentSelectedCount:(NSInteger)currentCount
                                          animation:(BOOL)flag
                                         completion:(void(^)(void))completion;

//选取图片结束
- (void)didFinishImagePicker:(TXImagePickerController *)picker;

@end

