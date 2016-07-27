//
//  NSDate+Utils.m
//  TXDemo
//
//  Created by frank on 16/6/5.
//  Copyright © 2016年 frank. All rights reserved.
//

#import "NSDate+Utils.h"
#import "NSDateFormatter+Utils.h"
#import "Comment.h"

@implementation NSDate (Utils)

- (NSString *)stringWithDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(8,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components]; //当前时间 0点时间
    
    NSInteger hour = [self hoursAfterDate:date];
    //    NSInteger hour = [self hour];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    if (hour <= 24 && hour >= 0) {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
    }else if (hour < 0 && hour >= -24) {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
    }else {
        dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    }
    ret = [dateFormatter stringFromDate:self];
    return ret;
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    if (ti < 0 && ti > -D_HOUR) {
        return -1;
    }
    return (NSInteger) (ti / D_HOUR);
}

@end
