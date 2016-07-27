//
//  NSDateFormatter+Utils.m
//  TXDemo
//
//  Created by frank on 16/6/5.
//  Copyright © 2016年 frank. All rights reserved.
//

#import "NSDateFormatter+Utils.h"

@implementation NSDateFormatter (Utils)

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

@end
