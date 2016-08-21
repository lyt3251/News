//
//  FavoritesManager.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "FavoritesManager.h"

NSString *favoritesProfile = @"MyFavorites.plist";

@interface FavoritesManager()
@property(nonatomic, strong)NSMutableArray *favoritesList;
@end

@implementation FavoritesManager
+ (instancetype)shareInstance
{
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        [self loadFromLocal];
    }
    return self;
}

-(void)loadFromLocal
{
    
    NSString *localFilePath = [self getFavoritesFile];
    NSMutableArray *array = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
    {
        array = [NSMutableArray arrayWithContentsOfFile:localFilePath];
        
    }
    self.favoritesList = array.count > 0?array:[NSMutableArray arrayWithCapacity:1];
}


-(NSString *)getFavoritesFile
{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", favoritesProfile]];
}

-(void)addNewsFavorites:(NSDictionary *)newsDic
{
    if(!newsDic)
    {
        return;
    }
    [self.favoritesList addObject:newsDic];
    
     NSString *localFilePath = [self getFavoritesFile];
    [self.favoritesList writeToFile:localFilePath atomically:YES];
}

-(void)removeFavoritesByNewsId:(int64_t)newsId
{
    __block NSUInteger index = self.favoritesList.count + 1000;
    [self.favoritesList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        NSNumber *newsIdNum = dic[@"GeneralID"];
        if(newsId == newsIdNum.intValue)
        {
            index = idx;
            *stop = YES;
        }
    }];
    if(index < self.favoritesList.count)
    {
        [self.favoritesList removeObjectAtIndex:index];
    }
    NSString *localFilePath = [self getFavoritesFile];
    [self.favoritesList writeToFile:localFilePath atomically:YES];
    
}

-(NSArray *)getFavoritesList
{
    return [NSArray arrayWithArray:self.favoritesList];
}

-(BOOL)isFavoritesByNewsId:(int64_t)newsId
{
    __block BOOL isFavorites = NO;

    [self.favoritesList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *newsIdNum = obj[@"GeneralID"];
        if(newsIdNum.longLongValue == newsId)
        {
            isFavorites = YES;
            *stop = YES;
        }
        
    }];
    
    return isFavorites;
}


@end
