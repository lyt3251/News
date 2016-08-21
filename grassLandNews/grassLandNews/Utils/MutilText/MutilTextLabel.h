//
//  MutilTextLabel.h
//  testMutil
//
//  Created by liuyuantao on 16/8/15.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BBCyclingLabel.h>

@interface MutilTextLabel : BBCyclingLabel
@property(nonatomic, strong)NSArray *textList;
@property(nonatomic, assign)CGFloat interval;
-(NSDictionary *)currentNewsInfo;
-(void)startShowTxt;
@end
