//
//  FavoritesManager.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesManager : NSObject
+ (instancetype)shareInstance;

-(void)addNewsFavorites:(NSDictionary *)newsDic;


-(void)removeFavoritesByNewsId:(int64_t)newsId;


-(NSArray *)getFavoritesList;

-(BOOL)isFavoritesByNewsId:(int64_t)newsId;
@end
