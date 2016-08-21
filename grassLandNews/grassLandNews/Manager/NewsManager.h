//
//  NewsManager.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "TXTaskManagerBase.h"

@interface NewsManager : TXTaskManagerBase

-(id)requestNewsTypesByNodeId:(int32_t)nodeId parentId:(int32_t)parentId depth:(int32_t)depth onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;


-(id)requestCycleList:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;

-(id)requestRollList:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;


-(id)requestNewsListByPage:(NSInteger)page nodeId:(int32_t)nodeId keyword:(NSString *)keyword ids:(NSArray *)ids clickdesc:(NSInteger)clickdesc onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;

-(id)requestNewsById:(int64_t)newsId onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;


-(id)requestNewsListBySearchWords:(NSString *)searchWord onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;

@end
