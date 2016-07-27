//
//  WXYNewListArchiverHelper.h
//  TXChatParent
//
//  Created by shengxin on 16/4/26.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXYNewListArchiverHelper : NSObject

+ (instancetype)shareInstance;
//增加已读url
- (void)addFile:(NSString*)aUrl;
//查询是否已读
- (BOOL)isRead:(NSString*)aUrl;
    
@end
