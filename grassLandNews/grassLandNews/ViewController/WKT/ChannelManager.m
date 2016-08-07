//
//  ChannelManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/7/28.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "ChannelManager.h"

NSString *channelProfile = @"channelProfile.plist";

@implementation ChannelManager


+ (instancetype)shareInstance
{
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/**
 *  获取频道列表
 *
 *  @return 频道列表
 */
-(NSArray *)getChannels
{
    
    NSString *localFilePath = [self getChannelFile];
    NSMutableArray *array = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
    {
        array = [NSMutableArray arrayWithContentsOfFile:localFilePath];
    }
    else
    {
        array = [NSMutableArray new];
        for(NSInteger i = 0; i < 10; i++)
        {
            NSDictionary *dic = @{@"channelId":@(i), @"channelName":[NSString stringWithFormat:@"测试测试%@", @(i)]};
            [array addObject:dic];
        }
        [array writeToFile:localFilePath atomically:YES];
    }
    
    return [NSArray arrayWithArray:array];
}


-(NSString *)getChannelFile
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", channelProfile]];
}

/**
 *  更新频道列表
 *
 *  @param array 新的频道列表
 */
-(void)updateChannels:(NSArray *)array
{
    if(array.count <= 0)
    {
        return ;
    }
    
    NSString *localFilePath = [self getChannelFile];
    [array writeToFile:localFilePath atomically:YES];
}
@end
