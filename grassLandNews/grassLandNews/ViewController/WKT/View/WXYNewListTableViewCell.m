//
//  WXYNewListTableViewCell.m
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WXYNewListTableViewCell.h"
#import "UIColor+Hex.h"
#import "WXYNewListArchiverHelper.h"

@interface WXYNewListTableViewCell()


@end

@implementation WXYNewListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.wImageView setImage:[UIImage imageNamed:@"wxyDefault"]];
    [self.wTitleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    self.wTitleLabel.numberOfLines = 1;
    self.wContentLabel.numberOfLines = 2;
    self.wContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.wContentLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.wContentLabel setTextColor:[UIColor colorWithHexStr:@"999999"]];
    self.wScanLabel.textAlignment = NSTextAlignmentRight;
    [self.wScanLabel setTextColor:[UIColor colorWithHexStr:@"999999"]];
    self.wScanLabel.font = [UIFont systemFontOfSize:10.0];
  
    [self.wlineView setBackgroundColor:[UIColor colorWithHexStr:@"e5e5e5"]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    self.iTagLabel.layer.cornerRadius = 2.0;
    self.iTagLabel.layer.masksToBounds = YES;
    self.iTagLabel.backgroundColor = [UIColor colorWithHexStr:@"389fff"];
    self.iTagLabel.textColor = [UIColor whiteColor];
    self.iTagLabel.text = @"最新";
    self.iTagLabel.textAlignment = NSTextAlignmentCenter;
    [self.iTagLabel setFont:[UIFont systemFontOfSize:10]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.wTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds) - 20.0f;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
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

#pragma mark - public
//- (void)setData:(TXPBArticleAbstract*)aModel{
//
//    self.wImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.wImageView.clipsToBounds = YES;
//    [self.wImageView  sd_setImageWithURL:[NSURL URLWithString:aModel.titleImgUrl] placeholderImage:[UIImage imageNamed:@"wxyDefault"]];
//    self.wTitleLabel.text = aModel.title;
//   
//    NSString *content = aModel.content;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:2.5];
//    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
//    
//    self.wContentLabel.attributedText = attributedString;
//    [self.wContentLabel sizeToFit];
//    
//    self.wScanLabel.text = [NSString stringWithFormat:@"阅读%lli",aModel.hits];
//    
//    BOOL a = [[WXYNewListArchiverHelper shareInstance] isRead:[NSString stringWithFormat:@"%@&pf=WJY" ,aModel.detailUrl ]];
//    if (a==YES) {
//        [self.wTitleLabel setTextColor:[UIColor colorWithHexStr:@"999999"]];
//    }else{
//        [self.wTitleLabel setTextColor:[UIColor colorWithHexStr:@"444444"]];
//    }
//    
//    NSTimeInterval time = [[self zeroOfDate] timeIntervalSince1970];
//
//    NSTimeInterval b =  aModel.publishOn/1000;
//    NSLog(@"%f,%f",b,time);
//    if (b>time) {
//        if (a==YES) {
//            self.iTagLabel.hidden = YES;
//        }else{
//            BOOL a = [[WXYNewListArchiverHelper shareInstance] isRead:[NSString stringWithFormat:@"%@&pf=WJY" ,aModel.detailUrl ]];
//            if(a==YES){
//                self.iTagLabel.hidden = YES;
//            }else{
//                self.iTagLabel.hidden = NO;
//            }
//        }
//    }else{
//        self.iTagLabel.hidden = YES;
//    }
//}
//
//- (void)setSearchData:(TXPBArticleAbstract*)aModel andSearchText:(NSString *)aSearchText{
//    
//    NSString *title = aModel.title;
//    NSRange range = [title rangeOfString:aSearchText];
//    if (range.location!=NSNotFound) {
//        NSString *str1,*str2;
//        str1 = [title substringToIndex:range.location];
//        str2 = [title substringFromIndex:range.location+range.length];
//        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexStr:@"444444"]
//                        range:NSMakeRange(0,range.location)];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:KColorAppMain
//                        range:NSMakeRange(range.location,aSearchText.length)];
//        [attrStr addAttribute:NSForegroundColorAttributeName
//                        value:[UIColor colorWithHexStr:@"444444"]
//                        range:NSMakeRange(range.location+aSearchText.length,title.length-aSearchText.length-range.location)];
//        
//        self.wTitleLabel.attributedText = attrStr;
//        
//    }else{
//        self.wTitleLabel.text = title;
//    }
//    
//    self.wContentLabel.numberOfLines = 2;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:2.5];
//    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:aModel.content];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, aModel.content.length)];
//    
//    
//    
//    NSRange range1 = [aModel.content rangeOfString:aSearchText];
//    if (range1.location!=NSNotFound) {
//        NSString *str1,*str2;
//        str1 = [aModel.content substringToIndex:range1.location];
//        str2 = [aModel.content substringFromIndex:range1.location+range1.length];
//        
//        
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:[UIColor colorWithHexStr:@"444444"]
//                                 range:NSMakeRange(0,range1.location)];
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:KColorAppMain
//                                 range:NSMakeRange(range1.location,aSearchText.length)];
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:[UIColor colorWithHexStr:@"444444"]
//                                 range:NSMakeRange(range1.location+aSearchText.length,aModel.content.length-aSearchText.length-range1.location)];
//        
//        self.wContentLabel.attributedText = attributedString;
//        
//    }else{
//        self.wContentLabel.text = aModel.content;
//    }
//    [self.wContentLabel sizeToFit];
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    self.wScanLabel.text = [NSString stringWithFormat:@"阅读%lli",aModel.hits];
//    
//    
//    NSTimeInterval time = [[self zeroOfDate] timeIntervalSince1970];
//    
//    NSTimeInterval b =  aModel.publishOn/1000;
//    
//    
//    self.iTagLabel.hidden = YES;
//    
//    [self.wImageView sd_setImageWithURL:[NSURL URLWithString:aModel.titleImgUrl] placeholderImage:[UIImage imageNamed:@"wxyDefault"]];
//}
//

- (NSDate *)zeroOfDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    [gregorian setTimeZone:gmt];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 0];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}
@end
