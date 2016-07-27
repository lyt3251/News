//
//  DataUtility.m
//  TXDemo-teacher
//
//  Created by frank on 16/6/14.
//  Copyright © 2016年 frank. All rights reserved.
//

#import "DataUtility.h"
#import <Reachability.h>
#import <MBProgressHUD.h>

//NotReachable = 0,
//ReachableViaWiFi = 2,
//ReachableViaWWAN = 1

@implementation DataUtility

// 判断网络状态
+ (NSInteger)networkStatus
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    return [reachability currentReachabilityStatus];
}
//toast
+ (void)toastWithMbprogresss:(NSString *)string showOn:(UIView *)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.minSize = CGSizeMake(135, 50);
    HUD.labelText = string;
    HUD.labelFont = [UIFont systemFontOfSize:15];
    HUD.mode = MBProgressHUDModeText;
    [HUD hide:YES afterDelay:1];
}
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (message && [message length]) {
        hud.labelText = message;
    }
    return hud;
}
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    UIView *viewToRemove = nil;
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[MBProgressHUD class]]) {
            viewToRemove = v;
        }
    }
    if (viewToRemove != nil) {
        MBProgressHUD *HUD = (MBProgressHUD *)viewToRemove;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:animated];
        return YES;
    } else {
        return NO;
    }
}

@end
