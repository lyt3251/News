//
//  NewsFileManger.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFileManger : NSObject

+ (instancetype)shareInstance;

-(void)requestFileById:(int64_t)newsId onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted;

@end
