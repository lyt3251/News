//
//  UIImage+extension.m
//  Frank微博
//
//  Created by qingyun on 15/7/9.
//  Copyright (c) 2015年 qingyun. All rights reserved.
//

#import "UIImage+extension.h"

@implementation UIImage (extension)

+ (UIImage *)clearImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2, 2), NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加外层半透明效果
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.f);
    CGContextAddRect(context, CGRectMake(0, 0, 2, 2));
    CGContextFillPath(context);
    UIImage *clearImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clearImage;
}


@end
