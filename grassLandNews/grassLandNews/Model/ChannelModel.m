//
//  ChannelModel.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"nodeId": @"NodeId",
             @"nodeName": @"NodeName",
             @"childChannels": @"arrChildId",
             @"parentId": @"ParentId",
             @"depth": @"Depth",
             };
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

@end
