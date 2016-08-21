//
//  TXTaskManagerBase.h
//  TXTrainingParent
//
//  Created by liuyuantao on 16/6/22.
//  Copyright © 2016年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface TXTaskManagerBase : NSObject

-(void)testRequest;


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
-(NSURLSessionDataTask *)requestByUrl:(NSString *)requestUrl requestParameters:(NSDictionary *)requestParameters progress:(void (^)(NSProgress *  uploadProgress))requestProgress onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;

@end
