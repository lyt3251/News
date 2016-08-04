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
#define kEdgeInsetsLeft         15
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

#define kColorGray4             [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
#define kColorGray5             [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]
#define kColorGray6             [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1]
#define kColorBlue1              [UIColor colorWithRed:48/255.0 green:183/255.0 blue:239/255.0 alpha:1]
#define kColorPinkLine          [UIColor colorWithRed:247/255.0 green:111/255.0 blue:113/255.0 alpha:0.3]


//新定义颜色
#define kColorType              RGBCOLOR(65,195,255)
#define kColorType1             RGBCOLOR(50,170,226)
#define kColorBackground        RGBCOLOR(0xf6,0xf6,0xf6)
#define kColorOrange            RGBCOLOR(255,147,61)
#define kColorBlack             KColorNewTitleTxt              //黑色字体
#define kColorLightBlack        RGBCOLOR(96,96,96)              //浅黑色字体
#define kColorLine              RGBCOLOR(0xea, 0xea, 0xea)           //分割线颜色


#define kColorClear                 [UIColor clearColor]
#define kColorWhite                 RGBCOLOR(254,254,254)           //白色字体
#define kColorGray                  RGBCOLOR(115,115,115)           //灰色字体
#define kColorGray1                 RGBCOLOR(73, 104, 119)
#define kColorGray2                 RGBCOLOR(158, 158, 158)
#define kColorGray3                 RGBCOLOR(240, 240, 240)
#define kColorLightGray             RGBCOLOR(159,160,160)           //浅灰色字体
#define kColorPink                  RGBCOLOR(253,133,132)           //粉色
#define kColorBlue                  RGBCOLOR(0, 160, 233)
#define kColorItem                  RGBCOLOR(147, 158, 166)         //底部导航颜色
#define kColorSection               RGBCOLOR(230, 230, 230)          //
#define KColorNormalTxt             RGBCOLOR(75, 75, 75)          //
#define KColorTitleTxt              RGBCOLOR(0x44, 0x44, 0x44) //标题颜色
#define KColorSubTitleTxt           RGBCOLOR(0x75, 0x75, 0x75) //子标题颜色
#define kColorNavigationTitle       RGBCOLOR(0x48, 0x48, 0x48)
#define kColorNavigationTitleDisable       RGBACOLOR(0x44, 0x44, 0x44, 0.5)
#define kColorCircleBg              RGBCOLOR(220, 219, 219)
#define kColorMessageText           RGBCOLOR(46,46,46)
#define kColorSearch                RGBCOLOR(0x82,0x82,0x82)
#define kColorBtn                   RGBCOLOR(0x83,0x83,0x83)
#define kColorStar                  RGBCOLOR(0xff,0xb5,0x56)
#define kColorBorder                RGBCOLOR(0xd0,0xd6,0xd9)
#define kColorBack                  RGBCOLOR(0xf1,0xf1,0xf1)

#define KColorBorderLine            RGBCOLOR(0xe5, 0xe5, 0xe5)


#define KColorNewTitleTxt           RGBCOLOR(0x33, 0x33, 0x33)
#define KColorNewSubTitleTxt        RGBCOLOR(0x99, 0x99, 0x99)
#define KColorNewTimeTxt            RGBCOLOR(0xb2, 0xb2, 0xb2)
#define KColorNewLine               RGBCOLOR(0xe5, 0xe5, 0xe5)
#define KColorResourceLine          RGBCOLOR(225, 225, 225)

#define KColorAppMain               RGBCOLOR(0x44, 0x99, 0x69) //app主色调
#define KColorAppMainP              RGBCOLOR(0x32, 0xaa, 0xe2) //app主色调按下效果

#define kColorChildhood             RGBCOLOR(0xff, 0x80, 0x62)
#define kColorNavigationBackGroundColor RGBCOLOR(0x01, 0x8c, 0xf5)
#define KColorBorderColor           RGBCOLOR(0xe8, 0xe8, 0xe8)

#define kColorNewsTitle             RGBCOLOR(0x22, 0x22, 0x22)
#define kColorNewsChannel           RGBCOLOR(0x99, 0x99, 0x99)


//新定义字体
#define kFontMiddle                 [UIFont systemFontOfSize:15]
#define kFontLarge                  [UIFont systemFontOfSize:16]


#define kFontNormal                 [UIFont systemFontOfSize:18]
#define kFontNormal_b               [UIFont boldSystemFontOfSize:18]
#define kFontMiddle_b               [UIFont boldSystemFontOfSize:15]
#define kFontSmall                  [UIFont systemFontOfSize:13]
#define kFontSmall_b                [UIFont boldSystemFontOfSize:13]
#define kFontLarge_b                [UIFont boldSystemFontOfSize:16]
#define kFontSubTitle               [UIFont systemFontOfSize:14]
#define kFontSubTitle_b             [UIFont boldSystemFontOfSize:14]
#define kFontTitle                  [UIFont systemFontOfSize:16]
#define kFontTimeTitle              [UIFont systemFontOfSize:11]

//font
#define kFontSuper              [UIFont systemFontOfSize:20]
#define kFontSuper_b            [UIFont boldSystemFontOfSize:18]
#define kFontLarge_1            [UIFont systemFontOfSize:17]
#define kFontLarge_1_b          [UIFont boldSystemFontOfSize:17]

#define kFontSmallBold          [UIFont boldSystemFontOfSize:12]
#define kFontTiny               [UIFont systemFontOfSize:13]
#define kFontMini               [UIFont systemFontOfSize:10]
#define kMessageTextFont        [UIFont systemFontOfSize:16]
#define kFontChildSection       [UIFont systemFontOfSize:12]

#define kFontMiddle_1_b          [UIFont boldSystemFontOfSize:15]
//字体
#define kFontSuperLarge_b        [UIFont systemFontOfSize:19]

#define KNavFontSize (ISSMALLIPHONE?kFontMiddle_1_b:kFontSuper_b)


#define kFontNewsTitle          [UIFont systemFontOfSize:18]
#define kFontNewsSubTitle       [UIFont systemFontOfSize:14]
#define kFontNewsChannel        [UIFont systemFontOfSize:12]


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
