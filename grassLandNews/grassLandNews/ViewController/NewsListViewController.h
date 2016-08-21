//
//  NewsListViewController.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/3.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, NewsListType)
{
    NewsListType_Favorites = 0,
    NewsListType_SubChannel,
};



@interface NewsListViewController : BaseViewController
@property(nonatomic, strong)NSString *ListTitle;
@property(nonatomic, strong)NSDictionary *channelDic;
@property(nonatomic, assign)NewsListType listType;
@end
