//
//  TXWebViewController.h
//  TXChatParent
//
//  Created by 陈爱彬 on 16/2/22.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "BaseViewController.h"

@interface TXWebViewController : BaseViewController

/**
 *  链接地址
 */
@property (nonatomic,copy) NSString *urlString;
/**
 *  需要过滤的主机地址
 */
@property (nonatomic,copy) NSString *filtedHost;
/**
 *  需要分享功能,默认为NO
 */
@property (nonatomic) BOOL requireShare;
/**
 *  是否自动检测web页内容并修改标题,默认为YES
 */
@property (nonatomic) BOOL automaticChangeTitle;
/**
 *  是否返回到最顶，默认为NO
 */
@property (nonatomic) BOOL backToTop;

- (instancetype)initWithURLString:(NSString *)urlString;
- (void)setShareUrl:(NSString*)aUrl;
@end
