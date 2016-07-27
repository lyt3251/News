//
//  WKTSortScrollView.h
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ getTapBtn)(NSString *selectName);


@interface WKTSortScrollView : UIScrollView

@property (nonatomic, copy) getTapBtn wBlock;

@end
