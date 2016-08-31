//
//  MutilTextLabel.h
//  testMutil
//
//  Created by liuyuantao on 16/8/15.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BBCyclingLabel.h>

@interface MutilTextLabel : UIView
@property(nonatomic, strong)NSArray *textList;
@property(nonatomic, assign)CGFloat interval;
@property(nonatomic, strong)UIFont *font;
@property(nonatomic, strong)UIColor *textColor;
-(NSDictionary *)currentNewsInfo;
-(void)startShowTxt;
@end
