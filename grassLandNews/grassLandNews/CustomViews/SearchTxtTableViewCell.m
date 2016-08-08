//
//  SearchTxtTableViewCell.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/8.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "SearchTxtTableViewCell.h"

@interface SearchTxtTableViewCell()
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIImageView *rightImgView;
@end

@implementation SearchTxtTableViewCell

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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = kFontNewsSubTitle;
    _titleLabel.textColor = kColorNewsTitle;
    [self.contentView addSubview:_titleLabel];
    
    
    _rightImgView = [[UIImageView alloc] init];
    _rightImgView.image = [UIImage imageNamed:@"Main_SearchKey"];
    [self.contentView addSubview:_rightImgView];
    
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kEdgeInsetsLeft);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(_rightImgView.image.size);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdgeInsetsLeft);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(_rightImgView.mas_left);
    }];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kColorLine;
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdgeInsetsLeft);
        make.right.mas_equalTo(-kEdgeInsetsLeft);
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(kLineHeight);
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
