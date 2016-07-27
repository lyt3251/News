//
//  DataUtility.h
//  TXDemo-teacher
//
//  Created by frank on 16/6/14.
//  Copyright © 2016年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface DataUtility : NSObject

//toast显示
//+ (void)toastWithMbprogresss:(NSString *)string showOn:(UIView *)view;
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view withMessage:(NSString *)message;
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated;
// 判断网络状态
+ (NSInteger)networkStatus;

@end
