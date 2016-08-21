//
//  NewsFileManger.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsFileManger.h"
#import "NewsManager.h"

NSString *FileCache = @"LocalFileCache/";

@interface NewsFileManger()


@end


@implementation NewsFileManger
+ (instancetype)shareInstance
{
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(void)requestFileById:(int64_t)newsId onCompleted:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error)) onCompleted
{
    NSString *filePath = [self filePath:newsId];
    if(filePath.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        if(onCompleted)
        {
            onCompleted(nil, [NSData dataWithContentsOfFile:filePath], nil);
            return;
        }
    }
    
    NewsManager *newsManager = [[NewsManager alloc] init];
    [newsManager requestNewsById:newsId onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if(!error)
        {
            NSData *fileDate = (NSData *)responseObject;
            [fileDate writeToFile:filePath atomically:YES];
        }
        
        if(onCompleted)
        {
            onCompleted(task, responseObject, error);
        }
    }];

}


-(NSString *)getPath
{

    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", FileCache]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:Nil error:&error];
    }
    
    return path;
}

-(NSString *)filePath:(int64_t)newsId
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.data", [self getPath], @(newsId)];
    return filePath;
}

@end
