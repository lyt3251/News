//
//  WKTSearchView.h
//  TXChatParent
//
//  Created by shengxin on 16/4/19.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^tapCell)(TXPBArticleAbstract* model);
@interface WKTSearchView : UIView

@property (nonatomic, strong) UITableView *iTableView;
//@property (nonatomic, copy) tapCell wDelegate;

- (void)setSearchData:(NSString*)aSearchText;

@end
