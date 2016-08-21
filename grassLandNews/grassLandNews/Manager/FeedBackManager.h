//
//  FeedBackManager.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "TXTaskManagerBase.h"

@interface FeedBackManager : TXTaskManagerBase
-(id)sendFeedInfoByContent:(NSString *)content withContact:(NSString *)contact onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;
@end
