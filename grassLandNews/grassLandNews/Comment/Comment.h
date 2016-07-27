//
//  Comment.h
//  TXDemo
//
//  Created by frank on 16/6/1.
//  Copyright © 2016年 frank. All rights reserved.
//

#ifndef Comment_h
#define Comment_h
#import <UIKit/UIKit.h>

#define D_HOUR		3600
#define TX_STATUS_UNAUTHORIZED                          403


#define IOS7_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"7"] != NSOrderedAscending)
#define __IOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))//ios8版本


/**
 *  数据库相关的常量
 *
 */
#define TX_CLIENT_NS_ERROR_DOMAIN                       @"com.training.ios.sdk"

/**
 *  UI 相关的常量
 */

//距离
#define kErrorMessage                           @"MESSAGE"
#define KMaxVerifyCode 6  //校验验证码的最大长度
#define KMinPasswordLen 6 //密码最小长度
#define KMaxPasswordLen 16 //密码最大长度

#define kStatusBarHeight        20.f    //状态栏高度
#define kNavigationHeight       52.f    //导航栏高度
#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height
#define kEdgeInsetsLeft         10
#define kLineHeight             0.5f
#define kTabBarHeight           50.f

static const CGFloat TXCellLeftMargin = 10.0f; //cell居左边距
static const CGFloat TXCellItemMargin = 15.0f; //cell2个控件之间的编剧
static const CGFloat TXCellRightMargin = TXCellLeftMargin; //cell居右边距

//颜色
#define TXBottomTabbarNormalColor ([UIColor colorWithHex:0x757a90]) //底部导航栏正常颜色
#define TXBottomTabbarHighLightColor ([UIColor colorWithHex:0x428ee4]) //底部导航栏选中颜色
#define TXSpaceLineColor ([UIColor colorWithHex:0xd6dee6]) //分割线颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kColorBackground  [UIColor whiteColor]
#define kColorWhite                 RGBCOLOR(254,254,254)
#define kColorBlack                 RGBCOLOR(0x33, 0x33, 0x33)
#define kColorClear                 [UIColor clearColor]
#define kColorItem                  RGBCOLOR(147, 158, 166)
#define kColorNavigationTitle       RGBCOLOR(0xff, 0xff, 0xff)
#define kColorNavigationTitleDisable  RGBACOLOR(0x44, 0x44, 0x44)
#define kColorGray                  RGBCOLOR(115,115,115)
#define kColorLine                  RGBCOLOR(216,216,216)
#define KColorSubTitleTxt           RGBCOLOR(0x75, 0x75, 0x75)
#define KColorTitleTxt              RGBCOLOR(0x44, 0x44, 0x44)
#define kColorNavigationBackGroundColor RGBCOLOR(0x01, 0x8c, 0xf5)

#define KColorAppMain               RGBCOLOR(0xf9, 0x74, 0x7a)

//字体
#define kFontSuperLarge_b        [UIFont systemFontOfSize:19]

#define kFontLarge_b             [UIFont systemFontOfSize:16]

#define kFontMiddle                 [UIFont systemFontOfSize:15]
#define kFontTimeTitle              [UIFont systemFontOfSize:13]



/**
 *  网络请求相关
 */

/**
 *  请求相关的常量
 */

static  NSString *TX_REQUEST_Base_Url = @"http://192.168.10.201:8080"; //请求服务器地址

static NSString *TX_REQUEST_VerifyCode_Url = @"/api/sendVerificationCode"; //发送验证码
static NSString *TX_REQUEST_Login_Url = @"/api/login"; //登录
static NSString *TX_REQUEST_MsgList_Url = @"/api/listSysMessage"; //消息列表
static NSString *TX_REQUEST_DelMsg_Url = @"/api/deleteSysMessage"; //删除消息
static NSString *TX_REQUEST_MarkReadStatusMsg_Url = @"/api/readMessage"; //设置消息为已读
static NSString *TX_REQUEST_ClearMsg_Url = @"/api/clearMessage"; //清空消息
static NSString *TX_REQUEST_UserInfo_Url = @"/api/userInfo"; //个人信息
static NSString *TX_REQUEST_ModifyUserName_Url = @"/api/changeUserName"; //修改昵称
static NSString *TX_REQUEST_ModifyPhoneNumber_Url = @"/api/changeMobile"; //修改手机号
static NSString *TX_REQUEST_ListOrders_Url = @"/api/listOrders"; //获取我的订单
static NSString *TX_REQUEST_DelOrder_Url = @"/api/deleteOrder"; //删除订单
static NSString *TX_REQUEST_ChildList_Url = @"/api/listChildren"; //获取孩子列表
static NSString *TX_REQUEST_UpdateChildrenInfo_Url = @"/api/updateChildrenInfo"; //修改孩子信息
static NSString *TX_REQUEST_FollowChild_Url = @"/api/followChild"; //关注孩子
static NSString *TX_REQUEST_UnFollowChild_Url = @"/api/unfollowChild"; //取消关注孩子
static NSString *TX_REQUEST_ListContacts_Url = @"/api/listContacts"; //获取联系人列表
static NSString *TX_REQUEST_ContactInfo_Url = @"/api/contactInfo"; //获取联系人详情
static NSString *TX_REQUEST_ListFeedback_Url = @"/api/listFeedback"; //获取意见反馈列表
static NSString *TX_REQUEST_FeedbackInfo_Url = @"/api/feedbackInfo"; //获取意见反馈详情
static NSString *TX_REQUEST_AddFeedback_Url = @"/api/addFeedback"; //添加意见反馈
static NSString *TX_REQUEST_CourseList_Url = @"/api/listCourses"; //课程列表
static NSString *TX_REQUEST_CourseDetail_Url = @"/api/course"; //课程详情
static NSString *TX_REQUEST_TaskList_Url = @"/api/listClassHomework"; //作业列表
static NSString *TX_REQUEST_CalentarMonth_Url = @"/api/listMonthCourse";//按月获取课程日历
static NSString *TX_REQUEST_CalentarDay_Url = @"/api/listDayCourse";//按天获取日历详情
static NSString *TX_REQUEST_TeacherInfo_Url = @"/api/teacherInfo";//教师详情
static NSString *TX_REQUEST_ListClass_Url = @"/api/listClasses"; //班级列表


//错误信息
#define TX_STATUS_OK                                    200
#define TX_STATUS_UNAUTHORIZED                          403
#define TX_STATUS_LOCAL_USER_EXPIRED                    -403
#define TX_STATUS_PB_PARSE_ERROR                        900
#define TX_STATUS_KICK_OFF                              1001
#define TX_STATUS_TIMEOUT                               8000
#define TX_STATUS_UN_KNOW_ERROR                         1000
#define TX_STATUS_DB_INIT_FAILED                        -200
#define TX_STATUS_PARAMETER_ERROR_CODE                  -400

#define TX_STATUS_UNAUTHORIZED_DESC                     @"未登录"
#define TX_STATUS_TIMEOUT_DESC                          @"请求超时，请重试"
#define TX_STATUS_LOCAL_USER_EXPIRED_DESC               @"本地登录态已经失效"
#define TX_STATUS_PARAMETER_ERROR                       @"参数错误"

/**
 *  配置文件
 */

#define TX_PROFILE_KEY_CURRENT_USERNAME                 @"_current.userame"
#define TX_PROFILE_KEY_CURRENT_TOKEN                    @"_current.token"
#define TX_APP_CONTEXT_FILE_NAME                        @"appContext.plist" //缓存文件名

/**
 *  常用操作宏
 */

#define TX_RUN_ON_MAIN(_code)                                   \
if ( [NSThread isMainThread]) {                                 \
_code;                                                      \
}else{                                                          \
dispatch_async(dispatch_get_main_queue(), ^{                \
_code;                                                  \
});                                                         \
}

#define TX_ERROR_MAKE(errorCode, errorMessage)                                      \
[NSError errorWithDomain:TX_CLIENT_NS_ERROR_DOMAIN                              \
code:errorCode                                              \
userInfo:@{ @"FILE" : @(__FILE__),                              \
@"LINE" : @(__LINE__),                              \
@"MESSAGE" : errorMessage }]

#define TX_ERROR_MAKE_WITH_URL(errorCode, errorMessage, url)                        \
[NSError errorWithDomain:TX_CLIENT_NS_ERROR_DOMAIN                              \
code:errorCode                                              \
userInfo:@{ @"FILE" : @(__FILE__),                              \
@"LINE" : @(__LINE__),                              \
@"URL"  : url,                                      \
@"MESSAGE" : errorMessage }]



#define TX_TIMETOINT64(time) ([(time) timeIntervalSince1970]*1000)

#endif /* Comment_h */
