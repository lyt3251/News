//
//  WKTSearchTableViewCell.m
//  TXChatParent
//
//  Created by shengxin on 16/4/19.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WKTSearchTableViewCell.h"
#import "UIColor+Hex.h"

@implementation WKTSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.wTitleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.wTitleLabel setTextColor:[UIColor colorWithHexStr:@"444444"]];
    
    [self.wScanLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self.wScanLabel setTextColor:[UIColor colorWithHexStr:@"999999"]];
    
    [self.wLineView setBackgroundColor:[UIColor colorWithHexStr:@"eeeeee"]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexStr:@"f4f5f6"];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

//- (void)setData:(TXPBArticleAbstract*)aModel andSearchText:(NSString*)aSearchText{
//    if (aModel==nil) {
//        return;
//    }
//    
//    self.wImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.wImageView.clipsToBounds = YES;
//    [self.wImageView sd_setImageWithURL:[NSURL URLWithString:aModel.titleImgUrl] placeholderImage:[UIImage imageNamed:@"wxyDefault"]];
//     NSString *content = aModel.title;
//    NSRange range = [content rangeOfString:aSearchText];
//  
//    if (range.location!=NSNotFound) {
//        NSString *str1,*str2;
//        str1 = [content substringToIndex:range.location];
//        str2 = [content substringFromIndex:range.location+range.length];
//        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:content];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexStr:@"444444"]
//                        range:NSMakeRange(0,range.location)];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexStr:@"389fff"]
//                        range:NSMakeRange(range.location,aSearchText.length)];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexStr:@"444444"]
//                        range:NSMakeRange(range.location+aSearchText.length,content.length-aSearchText.length-range.location)];
//        
//        self.wTitleLabel.attributedText = attrStr;
//        
//    }else{
//        self.wTitleLabel.text = aModel.title;
//    }
//    self.wScanLabel.text = [NSString stringWithFormat:@"阅读%lli",aModel.hits];
//}
@end
