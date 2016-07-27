//
//  WKTSortViewController.h
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^getSelectIndexIdAndData)(NSInteger selectIndex,NSArray *channelArr);

@interface WKTSortViewController : BaseViewController

@property (nonatomic, strong) UIImage *bgContentImage;//父视图截图
@property (nonatomic, copy) getSelectIndexIdAndData delegate;
@property (nonatomic, assign) NSInteger iSelectId;

@end
