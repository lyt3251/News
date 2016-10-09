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


//#define IOS7_OR_LATER       ([[[UIDevice currentDevice] systemVersion] compare:@"7"] != NSOrderedAscending)
#define IOS7_OR_LATER       (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_0)
#define __IOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))//ios8版本


/**
 *  数据库相关的常量
 *
 */
#define TX_CLIENT_NS_ERROR_DOMAIN                       @"com.training.ios.sdk"

/**
 *  UI 相关的常量
 */


/**
 *  通知
 */


#define TX_PUSH_SCREENCHANGED               @"Push_ScreenChanged" //背景图改变



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
#define kColorNewsRoll              RGBCOLOR(0x66, 0x66, 0x66)


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

static  NSString *REQUEST_Base_Url = @"http://appapi.grassland.gov.cn"; //请求服务器地址

static NSString *REQUEST_FeedBack_Url = @"/api/Feedback"; //意见反馈
static NSString *REQUEST_ALLType_Url = @"/api/GetAllType"; //文章类型列表
static NSString *REQUEST_CircleList_Url = @"/api/GetFirstPhoto"; //滚动图片列表
static NSString *REQUEST_RollList_Url = @"/api/GetFirstRoll"; //滚动新闻列表
static NSString *REQUEST_NewsList_Url = @"/api/GetArticle"; //新闻列表
static NSString *REQUEST_News_Url = @"/api/Info"; //新闻
static NSString *REQUEST_Searchwords_Url = @"/api/Searchwords"; //搜索关键词
static NSString *REQUEST_Update_Url = @"/api/VersionUpdate"; //升级
static NSString *REQUEST_PushMsg_Url = @"/api/GetMsgList";  //推送消息
static NSString *REQUEST_Home_Url = @"/api/GetHomeArticle";  //首页请求
static NSString *REQUEST_GetALLGwtg_Url = @"/api/GetAllgwtg";  //公告
static NSString *REQUEST_SpeicalArticle_Url = @"/api/GetSpecialArticle";  //专题文章列表


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

#define KPageNumber                                       20 //每页条数

/**
 *  配置文件
 */

#define TX_PROFILE_KEY_CURRENT_USERNAME                 @"_current.userame"
#define TX_PROFILE_KEY_CURRENT_TOKEN                    @"_current.token"
#define TX_APP_CONTEXT_FILE_NAME                        @"appContext.plist" //缓存文件名
#define TX_SETTING_FONT                                 @"setting_font" //字体配置


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




#define KSaveStr(value) (value.length > 0?value:@"")

#define TX_TIMETOINT64(time) ([(time) timeIntervalSince1970]*1000)

#pragma mark - 友盟分享key

//微信AppId
#define UMENG_WXAppId  @"wx6650656efc3ebade"
#define UMENG_WXAppSecrect  @"fe49fa5ea8b185536c287dec9650fde9"

//QQ的AppId
#define UMENG_QQAppId  @"1105568341"
#define UMENG_QQAppKey @"moD5alGKt1m2CAQ7"

#define UMENG_APPKEY @"57ac3a39e0f55a30ef0016b6"


#endif /* Comment_h */
