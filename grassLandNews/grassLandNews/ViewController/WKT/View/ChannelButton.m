//
//  ChannelButton.m
//  SortBtnExample
//
//  Created by shengxin on 16/4/14.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "ChannelButton.h"
#import "UIColor+Hex.h"

@interface ChannelButton()

@property (nonatomic, strong) UILabel *textLabel;

@end


@implementation ChannelButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithHexStr:@"f5f6f6"];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = [UIColor colorWithHexStr:@"444444"];
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.font = [UIFont systemFontOfSize:14.0];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithHexStr:@"cccccc"].CGColor;
        self.clipsToBounds = YES;
        self.textLabel = textLabel;
    }
    return self;
}

//布局子控件
-(void)layoutSubviews
{
    [super layoutSubviews];
    //1.textLabel位置
    self.textLabel.frame = self.bounds;
    
}

//设置文字
-(void)setText:(NSString *)text{
    _text = [text copy];
    self.textLabel.text = _text;
}

//拖拽
-(void)setBtnDrag:(BOOL)btnDrag{
    _btnDrag = btnDrag;
    if (_btnDrag) {
        self.textLabel.layer.borderColor = [UIColor colorWithRed:39.0/255.f green:128.0/255.f blue:248.0/255.f alpha:100.0/100.f].CGColor;
    }else{
        self.textLabel.layer.borderColor = [UIColor colorWithRed:205.0/255.f green:205.0/255.f blue:205.0/255.f alpha:100.0/100.f].CGColor;
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (!userInteractionEnabled) {
        self.textLabel.textColor = [UIColor colorWithHexStr:@"ff933d"];
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.layer.borderWidth = 0;
    }else{
        if (self.btnSelect) {
            [self setBtnSelect:YES];
        }else{
            
        }
    }
}

@end
