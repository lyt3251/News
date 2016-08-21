//
//  NewsModel.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsModel.h"


@implementation NewsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"GeneralID": @"GeneralID",
             @"nodeId": @"NodeID",
             @"nodeName": @"NodeName",
             @"title": @"Title",
             @"DefaultPicUrl": @"DefaultPicUrl",
             };
}



- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

@end
