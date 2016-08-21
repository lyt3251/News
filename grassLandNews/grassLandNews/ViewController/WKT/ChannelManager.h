//
//  ChannelManager.h
//  grassLandNews
//
//  Created by liuyuantao on 16/7/28.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelManager : NSObject


+ (instancetype)shareInstance;

/**
 *  获取频道列表
 *
 *  @return 频道列表
 */
-(NSArray *)getChannels;

/**
 *  更新频道列表
 *
 *  @param array 新的频道列表
 */
-(void)updateChannels:(NSArray *)array;

-(void)requestChannelFromServer;

-(NSArray *)getSubChannelsByChildList:(NSString *)childIds;

@end
