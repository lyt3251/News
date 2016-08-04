//
//  NewsOnlyTextTableViewCell.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsOnlyTextTableViewCell.h"

@interface NewsOnlyTextTableViewCell()
@property(nonatomic, strong)UIView *lineView;
@end

@implementation NewsOnlyTextTableViewCell

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
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = kColorNewsChannel;
    self.subTitleLabel.font = kFontNewsChannel;
    [self.contentView addSubview:self.subTitleLabel];
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kColorLine;
    [self.contentView addSubview:self.lineView];
    
    
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
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
