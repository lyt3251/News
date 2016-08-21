//
//  NewsManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsManager.h"

@implementation NewsManager

///api/GetAllType

//-(id)sendFeedInfoByContent:(NSString *)content withContact:(NSString *)contact onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
//{
//    if(content.length <= 0 || contact.length <= 0)
//    {
//        onCompleted(nil, nil, [NSError errorWithDomain:TX_STATUS_PARAMETER_ERROR code:TX_STATUS_PARAMETER_ERROR_CODE userInfo:nil]);
//        return nil;
//    }
//    
//    return [self requestByUrl:REQUEST_FeedBack_Url requestParameters:@{@"content":contact, @"deviceType":@(1), @"contact":contact} progress:nil onCompleted:onCompleted];
//}

-(id)requestNewsTypesByNodeId:(int32_t)nodeId parentId:(int32_t)parentId depth:(int32_t)depth onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    
    return [self requestByUrl:REQUEST_ALLType_Url requestParameters:@{@"nodeId":@(nodeId), @"parentId":@(parentId), @"depth":@(depth)} progress:nil onCompleted:onCompleted];

}


-(id)requestCycleList:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:REQUEST_CircleList_Url requestParameters:nil progress:nil onCompleted:onCompleted];
}

-(id)requestRollList:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{

    return [self requestByUrl:REQUEST_RollList_Url requestParameters:nil progress:nil onCompleted:onCompleted];
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
    return [self requestByUrl:REQUEST_News_Url requestParameters:@{@"id":@(newsId)} progress:nil onCompleted:onCompleted];
}

-(id)requestNewsListBySearchWords:(NSString *)searchWord onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    return [self requestByUrl:REQUEST_Searchwords_Url requestParameters:@{@"words":searchWord, @"pc":@(KPageNumber)} progress:nil onCompleted:onCompleted];
}





@end
