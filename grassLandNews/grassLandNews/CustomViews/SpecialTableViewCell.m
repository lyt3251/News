//
//  SpecialTableViewCell.m
//  grassLandNews
//
//  Created by liuyuantao on 16/9/6.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "SpecialTableViewCell.h"

@implementation SpecialTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupViews];
    }
    return self;
}


-(void)setupViews
{
    self.specialIcon = [[UIImageView alloc] init];
    self.specialIcon.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:self.specialIcon];
    [self.specialIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(self.specialIcon.mas_width).multipliedBy(170./305.);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = kColorNewsTitle;
    self.titleLabel.font = kFontNewsTitle;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.specialIcon.mas_bottom).with.offset(10);
        make.right.mas_equalTo(-15);
    }];    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kColorLine;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5f);
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
