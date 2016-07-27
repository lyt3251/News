//
//  RMCalendarMonthHeaderView.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarMonthHeaderView.h"
#import <Masonry.h>
#import <UIColor+Hex.h>

#define CATDayLabelWidth  (([UIScreen mainScreen].bounds.size.width-32)/7)

@interface RMCalendarMonthHeaderView()

@property (weak, nonatomic) UILabel *day1OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day2OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day3OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day4OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day5OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day6OfTheWeekLabel;
@property (weak, nonatomic) UILabel *day7OfTheWeekLabel;

@end

@implementation RMCalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initWithHeader];
    }
    return self;
}

- (void)initWithHeader
{
    self.clipsToBounds = YES;
    CGFloat headerWidth = [UIScreen mainScreen].bounds.size.width;
    //月份
    UILabel *masterLabel = [[UILabel alloc] init];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    masterLabel.font = [UIFont systemFontOfSize:18];
    masterLabel.textColor = [UIColor colorWithHex:0x018cf5];
    self.masterLabel = masterLabel;
    [self addSubview:self.masterLabel];
    [self.masterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17);
        make.centerX.mas_equalTo(0);
    }];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.masterLabel.mas_bottom).with.offset(16);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.upBtn = [[UIButton alloc]init];
    [self.upBtn setImage:[UIImage imageNamed:@"icon_left_nor"] forState:UIControlStateNormal];
    [self.upBtn setImage:[UIImage imageNamed:@"icon_left_sel"] forState:UIControlStateSelected];
    [self addSubview:self.upBtn];
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
    }];
    
    self.downBtn = [[UIButton alloc]init];
    [self.downBtn setImage:[UIImage imageNamed:@"icon_right_nor"] forState:UIControlStateNormal];
    [self.downBtn setImage:[UIImage imageNamed:@"icon_right_sel"] forState:UIControlStateSelected];
    [self addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(16);
    }];
    
    NSArray *textArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < textArray.count; i++) {
        [self initHeaderWeekText:textArray[i] titleColor:[UIColor colorWithHex:0x018cf5] x:CATDayLabelWidth * i];
    }
    
}

// 初始化数据
- (void)initHeaderWeekText:(NSString *)text titleColor:(UIColor *)color x:(CGFloat)x {
    UILabel *titleText = [[UILabel alloc]init];
    titleText.font = [UIFont systemFontOfSize:13];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.textColor = color;
    titleText.text = text;
    [self addSubview:titleText];
    [titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.masterLabel.mas_bottom).with.offset(34);
        make.left.mas_equalTo(x+16);
        make.width.mas_equalTo(CATDayLabelWidth);
    }];
}


@end

