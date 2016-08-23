//
//  NewsManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsManager.h"

@implementation NewsManager
-(id)requestNewsTypesByNodeId:(int32_t)nodeId parentId:(int32_t)parentId depth:(int32_t)depth onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(nodeId > 0)
    {
        [dic setValue:@(nodeId) forKey:@"nodeId"];
    }
    if(depth > 0)
    {
        [dic setValue:@(depth) forKey:@"depth"];
    }
    if(parentId > 0)
    {
        [dic setValue:@(parentId) forKey:@"parentId"];
    }
    
    
    return [self requestByUrl:REQUEST_ALLType_Url requestParameters:dic progress:nil onCompleted:onCompleted];

}


-(id)requestCycleListByNodeId:(NSInteger)nodeId  onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    NSDictionary *parameter = nil;
    if(nodeId != 0)
    {
        parameter = @{@"nodeId":@(nodeId)};
    }
    
    return [self requestByUrl:REQUEST_CircleList_Url requestParameters:parameter progress:nil onCompleted:onCompleted];
}

-(id)requestRollListByNodeId:(NSInteger)nodeId  onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    NSDictionary *parameter = nil;
    if(nodeId != 0)
    {
        parameter = @{@"nodeId":@(nodeId)};
    }
    return [self requestByUrl:REQUEST_RollList_Url requestParameters:parameter progress:nil onCompleted:onCompleted];
}


-(id)requestNewsListByPage:(NSInteger)page nodeId:(int32_t)nodeId keyword:(NSString *)keyword ids:(NSArray *)ids clickdesc:(NSInteger)clickdesc onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    for(NSNumber *newsId in ids)
    {
        if(mutableStr.length > 0)
        {
            [mutableStr appendFormat:@",%@", newsId];
        }
        else
        {
            [mutableStr appendFormat:@"%@", newsId];
        }
    }
    
    
    NSDictionary *parametes = @{@"pi":@(page), @"pc":@(KPageNumber), @"kw":keyword.length > 0?keyword:@"", @"clickdesc":@(clickdesc), @"Ids":mutableStr};
    return [self requestByUrl:REQUEST_NewsList_Url requestParameters:parametes progress:nil onCompleted:onCompleted];
    
}

-(id)requestNewsById:(int64_t)newsId onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:[NSString stringWithFormat:@"%@/%@", REQUEST_News_Url, @(newsId)] requestParameters:nil progress:nil onCompleted:onCompleted];
}

-(id)requestNewsListBySearchWords:(NSString *)searchWord page:(NSInteger)page onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:REQUEST_Searchwords_Url requestParameters:@{@"pi":@(page), @"words":searchWord.length > 0?searchWord:@"", @"pc":@(KPageNumber)} progress:nil onCompleted:onCompleted];
}


-(id)requestPushMsgsByPage:(NSInteger)page onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:REQUEST_PushMsg_Url requestParameters:@{@"pi":@(page), @"pc":@(KPageNumber)} progress:nil onCompleted:onCompleted];
}

-(id)requestHomeNewsList:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:REQUEST_Home_Url requestParameters:nil progress:nil onCompleted:onCompleted];
}


@end
