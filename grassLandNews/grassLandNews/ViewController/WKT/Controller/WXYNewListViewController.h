//
//  WXYNewListViewController.h
//  TXChatParent
//
//  Created by shengxin on 16/4/15.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewPagerController.h"

@interface WXYNewListViewController : ViewPagerController

/**
 *  根据channelID得到位置
 */
- (NSInteger)getIndexChannelFromName:(NSString*)aChannelID;

@end
