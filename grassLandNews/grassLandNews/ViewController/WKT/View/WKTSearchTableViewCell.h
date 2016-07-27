//
//  WKTSearchTableViewCell.h
//  TXChatParent
//
//  Created by shengxin on 16/4/19.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *wImageView;
@property (nonatomic, strong) IBOutlet UILabel *wTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *wScanLabel;
@property (nonatomic, strong) IBOutlet UIView *wLineView;


//- (void)setData:(TXPBArticleAbstract*)aModel andSearchText:(NSString*)aSearchText;
@end
