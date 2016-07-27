//
//  WXYNewSubListViewController.h
//  TXChatParent
//
//  Created by shengxin on 16/4/15.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//


#import "BaseViewController.h"

//typedef void (^tapCell)(TXPBArticleAbstract *model);

@interface WXYNewSubListViewController : BaseViewController

//@property (nonatomic, copy) tapCell tBlock;

- (void)loadData:(NSInteger)aChannelId;


@end
