//
//  AppDelegate.m
//  grassLandNews
//
//  Created by liuyuantao on 16/7/27.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "AppDelegate.h"
#import <RESideMenu.h>
#import "BaseViewController.h"
#import "LeftViewController.h"
#import "MidViewController.h"
#import "WXYNewListViewController.h"
#import "CustomNavigationController.h"
#import "FeedBackViewController.h"
#import "ChannelSortViewController.h"
#import "PushMsgViewController.h"
#import "TXWebViewController.h"
#import "NewsDetailViewController.h"
#import "SearchListViewController.h"
#import "CustomTabBarController.h"
#import "RDVTabBar.h"
#import "RDVTabBarItem.h"
#import <SDVersion.h>
#import "ChannelManager.h"
#import "UpdateManager.h"
#import "UIView+AlertView.h"
#import "UMessage.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置 AppKey 及 LaunchOptions
    [UMessage startWithAppkey:@"57ac3a39e0f55a30ef0016b6" launchOptions:launchOptions];
    
    //1.3.0版本开始简化初始化过程。如不需要交互式的通知，下面用下面一句话注册通知即可。
    [UMessage registerForRemoteNotifications];
    // Override point for customization after application launch.
    [self initWindows];
    NSLog(@"home:%@", NSHomeDirectory());
    [[ChannelManager shareInstance] requestChannelFromServer];
//    [self checkUpdate];
    return YES;
}


-(void)initWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    WXYNewListViewController *vc = [[WXYNewListViewController alloc] initWithNibName:nil bundle:nil];
    
    ChannelSortViewController *channelSortVC = [[ChannelSortViewController alloc] init];
    
    PushMsgViewController *pushVC = [[PushMsgViewController alloc] init];
    
    CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
    [tabBarController setViewControllers:@[vc, channelSortVC, pushVC]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
    
    CustomNavigationController *navigationController = [[CustomNavigationController alloc] initWithRootViewController:self.viewController];
    navigationController.navigationBarHidden = YES;
    
    
    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
    CustomNavigationController *leftNavigationController = [[CustomNavigationController alloc] initWithRootViewController:leftMenuViewController];
    leftNavigationController.navigationBarHidden = YES;
    
    // Create side menu controller
    //
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftNavigationController
                                                                   rightMenuViewController:nil];
    
    //
    self.window.rootViewController = sideMenuViewController;
    
    
////    FeedBackViewController *fbVC = [[FeedBackViewController alloc] init];
//    SearchListViewController *sortVC = [[SearchListViewController alloc] init];
//    
//    
//    CustomNavigationController *fbNav = [[CustomNavigationController alloc] initWithRootViewController:sortVC];
//    fbNav.navigationBarHidden = YES;
//    self.window.rootViewController = sortVC;
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)createTabBarView{

    WXYNewListViewController *vc = [[WXYNewListViewController alloc] initWithNibName:nil bundle:nil];
    
    ChannelSortViewController *channelSortVC = [[ChannelSortViewController alloc] init];

    PushMsgViewController *pushVC = [[PushMsgViewController alloc] init];
    
    CustomTabBarController *tabBarController = [[CustomTabBarController alloc] init];
    [tabBarController setViewControllers:@[vc, channelSortVC, pushVC]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
    
    CustomNavigationController *navigationController = [[CustomNavigationController alloc] initWithRootViewController:self.viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    NSArray *tabBarItemImages = @[@{@"title":@"首页",@"img":@"Nav_Main"}, @{@"title":@"频道",@"img":@"Nav_Channel"}, @{@"title":@"推送",@"img":@"Nav_Push"}];
    
    NSInteger index = 0;
    [tabBarController.tabBar setHeight:kTabBarHeight];
    tabBarController.tabBar.backgroundView.backgroundColor = kColorWhite;
    [tabBarController.tabBar addSubview:[[UIView alloc] initLineWithFrame:CGRectMake(0, 0, kScreenWidth, kLineHeight)]];
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        NSDictionary *dic = [tabBarItemImages objectAtIndex:index];
//        [item setTitle:dic[@"title"]];
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            item.unselectedTitleAttributes = @{
                                               NSFontAttributeName: [UIFont systemFontOfSize:12],
                                               NSForegroundColorAttributeName: kColorItem,
                                               };
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:12],
                                             NSForegroundColorAttributeName: kColorType,
                                             };
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            item.unselectedTitleAttributes = @{
                                               UITextAttributeFont: [UIFont systemFontOfSize:12],
                                               UITextAttributeTextColor: kColorItem,
                                               };
            item.selectedTitleAttributes = @{
                                             UITextAttributeFont: [UIFont systemFontOfSize:12],
                                             UITextAttributeTextColor: kColorType,
                                             };
#endif
        }
        [item setBadgeBackgroundColor:RGBCOLOR(255, 0, 0)];
        item.badgePositionAdjustment = UIOffsetMake(-4, 3);
        if ([SDVersion deviceSize] == Screen4Dot7inch ||
            [SDVersion deviceSize] == Screen5Dot5inch){
            [item setBadgeTextFont:[UIFont systemFontOfSize:4.5f]];
        }else{
            [item setBadgeTextFont:[UIFont systemFontOfSize:3.f]];
        }
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",dic[@"img"]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"img"]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)checkUpdate
{
    UpdateManager *updateM = [[UpdateManager alloc] init];
    @weakify(self);
    [updateM requestUpdateMsg:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        
        UIAlertView *alert = nil;
        
        if( status.integerValue > 0)
        {
            NSString *msg = dic[@"data"][@"content"];
            alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 2;
            
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"升级提示" message:dic[@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 3;
        }
        [alert show];
        
        
    }];

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0)
{
    NSString *deviceTokenString = [[NSString alloc] initWithFormat:@"deviceTokenString %@", deviceToken];
    NSLog(@"deviceTokenString:%@", deviceTokenString);
}


@end
