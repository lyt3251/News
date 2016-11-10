//
//  ChannelManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/7/28.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "ChannelManager.h"
#import "NewsManager.h"
#import "ChannelModel.h"

NSString *channelProfile = @"channelProfile.plist";
NSString *topProfile = @"topProfile.plist";

@interface ChannelManager()
{


}
@property(nonatomic, strong)NSArray *channels;
@property(nonatomic, strong)NSArray *topChannels;
@end

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

-(id)init
{
    self = [super init];
    if(self)
    {
        [self loadFromLocal];
    }
    return self;
}

-(void)loadFromLocal
{

    NSString *localFilePath = [self getChannelFile];
    NSMutableArray *array = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
    {
        array = [NSMutableArray arrayWithContentsOfFile:localFilePath];
        
    }
    self.channels = [NSArray arrayWithArray:array];
    
    NSString *localTopFilePath = [self getTopChannelFile];
    NSMutableArray *topArray = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localTopFilePath])
    {
        topArray = [NSMutableArray arrayWithContentsOfFile:localTopFilePath];
        
    }
    self.topChannels = [NSArray arrayWithArray:topArray];
    
    
}



/**
 *  获取频道列表
 *
 *  @return 频道列表
 */
-(NSArray *)getChannels
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];

    for(NSDictionary *dic in self.channels)
    {
        if(((NSNumber *)dic[@"ParentId"]).integerValue == 0)
        {
            [array addObject:dic];
        }
    }
    
    return [NSArray arrayWithArray:array];
}


-(NSArray *)getTopChannels
{
    return self.topChannels;
}


-(NSArray *)getSubChannelsByChildList:(NSString *)childIds
{
    if(childIds.length <= 0)
    {
        return nil;
    }
    NSMutableArray *childArray = [NSMutableArray  arrayWithCapacity:1];
    NSArray *array = [childIds componentsSeparatedByString:@","];
    for(NSString *childId in array)
    {
        [self.channels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *channelDic = (NSDictionary *)obj;
            NSNumber *parentId = channelDic[@"NodeID"];
            if(parentId.integerValue == childId.integerValue)
            {
                [childArray addObject:channelDic];
            }
        }];
    }
    return [NSArray arrayWithArray:childArray];
}


-(NSString *)getChannelFile
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", channelProfile]];
}

-(NSString *)getTopChannelFile
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", topProfile]];
}


/**
 *  更新频道列表
 *
 *  @param array 新的频道列表
 */
//@"nodeId": @"NodeId",
//@"nodeName": @"NodeName",
//@"childChannels": @"arrChildId",
//@"parentId": @"ParentId",
//@"depth":

-(void)updateChannels:(NSArray *)array
{
    if(array.count <= 0)
    {
        return ;
    }
    
//    NSMutableArray *dicArray = [NSMutableArray arrayWithCapacity:1];
//    for(ChannelModel *channelModel in array)
//    {
//        if(!channelModel)
//        {
//            return;
//        }
//        NSDictionary *dic = @{@"NodeId":KSaveStr(channelModel.nodeId),
//                              @"NodeName":KSaveStr(channelModel.nodeName),
//                              @"arrChildId":KSaveStr(channelModel.childChannels),
//                              @"ParentId":@(channelModel.parentId),
//                              @"Depth":@(channelModel.depth)};
//        [dicArray addObject:dic];
//    }
    
    self.channels = array;
    NSString *localFilePath = [self getChannelFile];
    [array writeToFile:localFilePath atomically:YES];
}

-(void)updateTopChannels:(NSArray *)array
{
    if(array.count <= 0)
    {
        return ;
    }
    
    //    NSMutableArray *dicArray = [NSMutableArray arrayWithCapacity:1];
    //    for(ChannelModel *channelModel in array)
    //    {
    //        if(!channelModel)
    //        {
    //            return;
    //        }
    //        NSDictionary *dic = @{@"NodeId":KSaveStr(channelModel.nodeId),
    //                              @"NodeName":KSaveStr(channelModel.nodeName),
    //                              @"arrChildId":KSaveStr(channelModel.childChannels),
    //                              @"ParentId":@(channelModel.parentId),
    //                              @"Depth":@(channelModel.depth)};
    //        [dicArray addObject:dic];
    //    }
    
    self.topChannels = array;
    NSString *localFilePath = [self getTopChannelFile];
    [array writeToFile:localFilePath atomically:YES];
}




-(void)requestChannelFromServer
{
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [newsManager requestNewsTypesByNodeId:0 parentId:0 depth:0 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(status.integerValue > 0)
        {
//            NSArray *array = [self getChannelsByDic:dic[@"data"]];
            [self updateChannels:dic[@"data"]];
        }
    }];
}


-(void)requestTopChannelFromServer
{
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [newsManager requestNewsTypesByNodeId1:0 parentId:0 depth:0 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(status.integerValue > 0)
        {
            //            NSArray *array = [self getChannelsByDic:dic[@"data"]];
            [self updateTopChannels:dic[@"data"]];
        }
    }];
}





-(NSArray *)getChannelsByDic:(NSArray *)dicArray
{
    if(dicArray.count <= 0)
    {
        return nil;
    }
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:1];

    for(NSDictionary *dic in dicArray)
    {
        NSError *error;
        ChannelModel *channelModel = [MTLJSONAdapter modelOfClass:ChannelModel.class fromJSONDictionary:dic error:&error];
        if(channelModel)
        {
            [mutableArray addObject:channelModel];
        }
    }
    return [NSArray arrayWithArray:mutableArray];
    
}


@end
