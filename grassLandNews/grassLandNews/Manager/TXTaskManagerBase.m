//
//  TXTaskManagerBase.m
//  TXTrainingParent
//
//  Created by liuyuantao on 16/6/22.
//  Copyright © 2016年 frank. All rights reserved.
//

#import "TXTaskManagerBase.h"
//#import <CocoaLumberjack.h>
#import <SDVersion.h>
#import "UIDevice+IdentifierAddition.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AFNetworking.h>


@implementation TXTaskManagerBase

-(void)testRequest
{
    [self requestByUrl:@"/api/Feedback" requestParameters:@{@"deviceType":@(1), @"content":@"123", @"contact":@"aa@qq.com"} progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress");
    } onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSLog(@"task:%@ responseObject:%@, error:%@", task, responseObject, error);
    }];
}

/**
 *  请求的公用函数 会自动添加系统参数
 *
 *  @param requestUrl        相关请求的url  ex:/api/sendVerificationCode
 *  @param requestParameters 请求参数
 *  @param requestProgress   进度
 *  @param onCompleted       完成信息
 *
 *  @return 当前当前请求标识
 */
-(NSURLSessionDataTask *)requestByUrl:(NSString *)requestUrl requestParameters:(NSDictionary *)requestParameters progress:(void (^)(NSProgress *  uploadProgress))requestProgress onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@", REQUEST_Base_Url, requestUrl];

//    NSDictionary *parametersDic = @{@"parameters":(requestParameters != nil?requestParameters:@"")};
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:postUrl parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *error;
    //添加 公用参数
//    NSData *systemJsonData = [NSJSONSerialization dataWithJSONObject:[self systemParameters]
//                                                             options:0
//                                                               error:&error];
//    NSString *systemJsonString = [[NSString alloc] initWithData:systemJsonData encoding:NSUTF8StringEncoding];
//    [req setValue:systemJsonString forHTTPHeaderField:@"x-mobile-info"];
    
    //添加http体
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParameters
//                                                       options:0
//                                                         error:&error];
    NSMutableString *bodyStr = [[NSMutableString alloc] init];
    for(NSString *key in [requestParameters allKeys])
    {
        id value = requestParameters[key];
        if(bodyStr.length > 0)
        {
            [bodyStr appendFormat:@"&%@=%@", key, value];
        }
        else
        {
            [bodyStr appendFormat:@"%@=%@", key, value];
        }
    }
    
    
//    NSString *jsonString = [[NSString alloc] initWithData:[bodyStr da] encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    __block NSURLSessionDataTask *task = [manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if(requestProgress)
        {
            TX_RUN_ON_MAIN(requestProgress(downloadProgress));
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(onCompleted)
        {
            TX_RUN_ON_MAIN(onCompleted(task, responseObject, error));
        }
    }];
    [task resume];
    
    return task;
}

-(NSDictionary *)systemParameters
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setValue:@"token" forKey:@"token"];
    
    NSString *plantName = @"unKnown";
#ifdef TX_CHAT_CLIENT_PLATFORM
    plantName = TX_CHAT_CLIENT_PLATFORM;
#endif
    
    NSString *plantVersion = [NSString stringWithFormat:@"%@_%@", plantName,  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
    [mutableDic setValue:plantVersion forKey:@"ver"];
    [mutableDic setValue:@"iosversion" forKey:@"iosVersion"];
    [mutableDic setValue:@"ios" forKey:@"os"];
    return mutableDic;
}


- (NSString *) uniqueGlobalDeviceIdentifier
{
    NSString *uniqueIdentifier = nil;
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] < 7.0) {
        NSString *macaddress = [[UIDevice currentDevice] macaddress];
        uniqueIdentifier = [macaddress stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    else
    {
        uniqueIdentifier = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return uniqueIdentifier;
    
}

- (NSString*)deviceString
{
    return [NSString stringWithFormat:@"%@", DeviceVersionNames[[SDVersion deviceVersion]]];
}

@end