//
//  FeedBackManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "FeedBackManager.h"

@implementation FeedBackManager

-(id)sendFeedInfoByContent:(NSString *)content withContact:(NSString *)contact onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    if(content.length <= 0 || contact.length <= 0)
    {
        onCompleted(nil, nil, [NSError errorWithDomain:TX_STATUS_PARAMETER_ERROR code:TX_STATUS_PARAMETER_ERROR_CODE userInfo:nil]);
        return nil;
    }
    
    return [self requestByUrl:REQUEST_FeedBack_Url requestParameters:@{@"content":contact, @"deviceType":@(1), @"contact":contact} progress:nil onCompleted:onCompleted];
}

@end
