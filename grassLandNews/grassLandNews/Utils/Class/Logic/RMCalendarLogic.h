//
//  RMCalendarLogic.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMCalendarModel.h"

/**
 *  日历显示的月数
 */
typedef NS_ENUM(NSInteger, CalendarShowType){
    /**
     *  只显示当月
     */
    CalendarShowTypeSingle,
    /**
     *  显示多个月数
     */
    CalendarShowTypeMultiple
};

@interface RMCalendarLogic : NSObject

@property (nonatomic,strong) NSDate *nowShowDate;
@property (nonatomic) NSInteger num;
@property (nonatomic,strong) NSMutableArray *calendarDays;

-(NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable;

- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type;


- (NSMutableArray *)reloadCalendarView:(NSDate *)date selectDate:(NSDate *)selectDate needDays:(int)days showType:(CalendarShowType)type;
- (void)selectLogic:(RMCalendarModel *)dayModel;

@end
