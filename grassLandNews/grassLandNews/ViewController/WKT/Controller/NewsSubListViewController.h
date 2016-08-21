//
//  NewsSubListViewController.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsSubListViewController : BaseViewController
@property(nonatomic, strong)NSDictionary *channelInfo;
-(void)reloadAllDatas;
@end
