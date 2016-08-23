//
//  UpdateManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "UpdateManager.h"

@implementation UpdateManager


-(id)requestUpdateMsg:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
     NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return [self requestByUrl:REQUEST_Update_Url requestParameters:@{@"versionNum":@"1.0.0", @"appType":@(1), @"system":KSaveStr(systemVersion)} progress:nil onCompleted:onCompleted];
}

@end
