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
#import "MiddleViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    MidViewController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[MidViewController alloc] init]];
//    MidViewController *MidViewController =  [[MidViewController alloc] init];
    MiddleViewController *vc = [[MiddleViewController alloc] initWithNibName:nil bundle:nil];
    CustomNavigationController *loginNV = [[CustomNavigationController alloc]
                                           initWithRootViewController:vc];
    loginNV.navigationBarHidden = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    MidViewController *midVC = [[MidViewController alloc] init];
    
    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
    
    // Create side menu controller
    //
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:loginNV
                                                                    leftMenuViewController:leftMenuViewController
                                                                   rightMenuViewController:nil];
//    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    
    // Make it a root controller
    //
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
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

@end
