//
//  RMCollectionCell.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCollectionCell.h"
#import "UIView+CustomFrame.h"
#import "RMCalendarModel.h"
#import <UIColor+Hex.h>
#import "TicketModel.h"

#define kFont(x) [UIFont systemFontOfSize:x]


@interface RMCollectionCell()

/**
 *  显示日期
 */
@property (nonatomic, weak) UILabel *dayLabel;
/**
 *  选中的背景图片
 */
@property (nonatomic, weak) UIImageView *selectImageView;


@end

@implementation RMCollectionCell

- (nonnull instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initCellView];
    return self;
}

- (void)initCellView {
    
    //选中时显示的图片
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width*0.8, self.bounds.size.width * 0.8)];
    self.selectImageView = selectImageView;
    [self addSubview:selectImageView];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, self.bounds.size.width, self.bounds.size.width * 0.5)];
    dayLabel.font = kFont(13);
    self.selectImageView.center = dayLabel.center;
    dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel = dayLabel;
    [self addSubview:dayLabel];
}

- (void)setModel:(RMCalendarModel *)model {
    _model = model;
    
    switch (model.style) {
        case CellDayTypeEmpty:
            self.selectImageView.hidden = YES;
            self.dayLabel.hidden = YES;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case CellDayTypePast:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = NO;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor colorWithHex:0x777777];
            self.selectImageView.image = [UIImage imageNamed:@"bg_cal02"];
            break;
            
        case CellDayTypeFutur:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = YES;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor colorWithHex:0x777777];
            break;
            
        case CellDayTypeClick:
            self.dayLabel.hidden = NO;
            self.selectImageView.hidden = NO;
            self.dayLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.day];
            self.dayLabel.textColor = [UIColor colorWithHex:0xffffff];
            self.selectImageView.image = [UIImage imageNamed:@"bg_cal01"];
            break;
            
        default:
            break;
    }
    
}

@end
