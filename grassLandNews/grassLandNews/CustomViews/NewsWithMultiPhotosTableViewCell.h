//
//  NewsWithMultiPhotosTableViewCell.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/10.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsWithMultiPhotosTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *subTitleLabel;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)NSArray *photos;
@end
