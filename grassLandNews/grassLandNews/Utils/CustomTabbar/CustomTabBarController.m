//
//  CustomTabBarController.m
//  TXChat
//
//  Created by Cloud on 15/6/30.
//  Copyright (c) 2015年 lingiqngwan. All rights reserved.
//

#import "CustomTabBarController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@implementation CustomTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //禁用滑动返回
    self.fd_interactivePopDisabled = YES;
}
- (void)setNeedsStatusBarAppearanceUpdate{
    if (IOS7_OR_LATER) {
        [super setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!IOS7_OR_LATER) {
        //ios7以前的系统禁掉动画显示，性能优化
        [super setTabBarHidden:hidden animated:NO];
    }else{
        [super setTabBarHidden:hidden animated:animated];
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    UIViewController *vc = [self.viewControllers objectAtIndex:selectedIndex];

}
#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
