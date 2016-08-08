//
//  UILabel+Extra.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "UILabel+Extra.h"

@implementation UILabel (Extra)

//添加带间距的字符串
-(void)setTextByStr:(NSString *)str WithSpace:(CGFloat)space
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str.length > 0?str:@""];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:space];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    self.attributedText = attributedString;
    
}


@end
