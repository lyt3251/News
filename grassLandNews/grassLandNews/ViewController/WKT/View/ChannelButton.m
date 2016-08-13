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
        self.backgroundColor = kColorClear;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = kColorWhite;
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.font = [UIFont systemFontOfSize:16.0];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textLabel];
        
        self.layer.cornerRadius = 12.0;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = kColorWhite.CGColor;
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
        self.textLabel.layer.borderColor = kColorWhite.CGColor;
    }else{
        self.textLabel.layer.borderColor = kColorWhite.CGColor;
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (!userInteractionEnabled) {
        self.textLabel.textColor = kColorWhite;
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
//        self.layer.borderWidth = 0;
    }else{
        if (self.btnSelect) {
            [self setBtnSelect:YES];
        }else{
            
        }
    }
}

@end
