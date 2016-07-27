//
//  CustomAlertView.h
//  TXChat
//
//  Created by Cloud on 15/6/9.
//  Copyright (c) 2015年 lingiqngwan. All rights reserved.
//

#import "CustomIOSAlertView.h"

@interface CustomAlertView : CustomIOSAlertView

@property (nonatomic, strong) UIColor *bgColor;

- (CGSize)countScreenSize;
- (CGSize)countDialogSize;
- (UIView *)createContainerView;
- (void)applyMotionEffects;

@end
