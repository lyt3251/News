//
//  NewsWithPhotoTableViewCell.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/3.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsWithPhotoTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *rightImageView;
@property(nonatomic, strong)UILabel *subTitleLabel;
@property(nonatomic, strong)UILabel *timeLabel;

@property(nonatomic, strong)UIView *lineView;
@end
