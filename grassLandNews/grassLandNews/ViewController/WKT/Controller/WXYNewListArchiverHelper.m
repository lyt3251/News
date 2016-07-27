//
//  WXYNewListArchiverHelper.m
//  TXChatParent
//
//  Created by shengxin on 16/4/26.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WXYNewListArchiverHelper.h"

@implementation WXYNewListArchiverHelper

#pragma mark - public
+ (instancetype)shareInstance{
    static WXYNewListArchiverHelper *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[WXYNewListArchiverHelper alloc] init];
    });
    return obj;
}

- (void)addFile:(NSString*)aUrl{
    NSArray *oldDataArr = [self getFileData];
    NSMutableArray *newArr;
    if (oldDataArr==nil||![oldDataArr isKindOfClass:[NSMutableArray class]]) {
        newArr = [[NSMutableArray alloc] initWithArray:[NSArray array]];
    }else{
        newArr = [[NSMutableArray alloc] initWithArray:oldDataArr];
    }

    [newArr addObject:aUrl];
    NSMutableData *data = [NSMutableData data];
    //创建一个归档类
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:newArr forKey:@"array"];
    [archiver finishEncoding];
    //将数据写入文件里
    [data writeToFile:[self filePath] atomically:YES];
}

- (BOOL)isRead:(NSString*)aUrl{
    NSArray *array = [self getFileData];
    if (array==nil||![array isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    for(int i=0;i<array.count;i++){
        NSString *a = [array objectAtIndex:i];
        if ([a isEqualToString:aUrl]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - private
- (NSArray*)getFileData{
    NSMutableData *data1 = [NSMutableData dataWithContentsOfFile:[self filePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data1];
    NSArray *array  = [unarchiver decodeObjectForKey:@"array"];
    return array;
}

-(NSString *)filePath{
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
    NSString *fileName = [NSString stringWithFormat:@"%@HistoryReadFile",@""];
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:fileName];
    return path;
}


@end
