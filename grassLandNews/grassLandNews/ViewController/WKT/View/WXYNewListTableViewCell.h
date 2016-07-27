//
//  WXYNewListTableViewCell.h
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXYNewListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *wImageView;
@property (nonatomic, strong) IBOutlet UILabel *wTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *wContentLabel;
@property (nonatomic, strong) IBOutlet UILabel *wScanLabel;
@property (nonatomic, strong) IBOutlet UIView *wlineView;
@property (nonatomic, strong) IBOutlet UILabel *iTagLabel;

//- (void)setData:(TXPBArticleAbstract*)aModel;
//- (void)setSearchData:(TXPBArticleAbstract*)aModel andSearchText:(NSString *)aSearchText;

@end
