//
//  NewsWithMultiPhotosTableViewCell.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/10.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsWithMultiPhotosTableViewCell.h"

@interface NewsWithMultiPhotosTableViewCell()
@property(nonatomic, strong)UIView *photoViews;
@end

@implementation NewsWithMultiPhotosTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)setupViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = kColorNewsTitle;
    self.titleLabel.font = kFontNewsTitle;
    self.titleLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = kColorNewsChannel;
    self.subTitleLabel.font = kFontNewsChannel;
    [self.contentView addSubview:self.subTitleLabel];
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kColorLine;
    [self.contentView addSubview:self.lineView];
    
    self.photoViews = [[UIView alloc] init];
    [self.contentView addSubview:self.photoViews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.photoViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(72);
    }];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.photoViews removeAllSubviews];
    for(NSInteger i = 0; i < photos.count; i++)
    {
        NSString *url = photos[i];
        if(url.length <= 0)
        {
            continue;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        [self.photoViews addSubview:imageView];
        imageView.frame = CGRectMake(kEdgeInsetsLeft +i*(108 + 10), 0, 108, 72);
    }
}


@end
