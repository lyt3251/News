//
//  MutilTextLabel.m
//  testMutil
//
//  Created by liuyuantao on 16/8/15.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "MutilTextLabel.h"

@interface MutilTextLabel()
@property(nonatomic, assign)NSInteger index;
@property (nonatomic, strong)dispatch_source_t timer;
@property(nonatomic, strong)UILabel *scrollLabel;
@property(nonatomic, strong)UILabel *secondLabel;
@property(nonatomic, assign)BOOL isAnimationing;

@end

@implementation MutilTextLabel

-(id)init
{
    self = [super init];
    if(self)
    {
        _index = 0;
        _interval = 2.0f;
        _isAnimationing = NO;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)startShowTxt
{
    if(self.textList.count <= 0)
    {
        return ;
    }
    if(!self.scrollLabel)
    {
        self.scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width +50, self.frame.size.height)];
        self.scrollLabel.font = self.font;
        self.scrollLabel.textColor = self.textColor;
        [self addSubview:self.scrollLabel];
    }
    if(!self.secondLabel)
    {
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollLabel.frame.origin.x+self.scrollLabel.frame.size.width, self.scrollLabel.frame.origin.y, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height)];
        self.secondLabel.font = self.scrollLabel.font;
        self.secondLabel.textColor = self.scrollLabel.textColor;
        [self addSubview:self.secondLabel];
    }
    [CATransaction begin];
    [self.layer removeAllAnimations];
    [CATransaction commit];
    if(!self.isAnimationing)
    {
        [self addAnimation];
    }
    self.clipsToBounds = YES;
    self.isAnimationing = YES;
}


- (void)addAnimation{
    
    CGRect scrollFrame = self.scrollLabel.frame;
    CGRect secondFrame = self.secondLabel.frame;
    NSDictionary *dic = self.textList[self.index];
    self.scrollLabel.text = dic[@"Title"];
    NSDictionary *secondDic = nil;
    if(self.index > self.textList.count -2)
    {
        secondDic = self.textList[0];
    }
    else
    {
        secondDic = self.textList[self.index + 1];
    }
    self.secondLabel.text = secondDic[@"Title"];
    NSLog(@"frist:%@, second:%@", self.scrollLabel.text, self.secondLabel.text);
    
    [UIView animateWithDuration:self.interval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.scrollLabel.frame = CGRectMake(-self.scrollLabel.frame.size.width, self.scrollLabel.frame.origin.y, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
        self.secondLabel.frame = CGRectMake(0, self.secondLabel.frame.origin.y, self.secondLabel.frame.size.width, self.secondLabel.frame.size.height);
    } completion:^(BOOL finished) {
        self.scrollLabel.frame = scrollFrame;
        self.secondLabel.frame = secondFrame;
        self.index ++;
        if(self.index >= self.textList.count)
        {
            self.index = 0;
        }
        NSLog(@"self.index:%@", @(self.index));
        [self addAnimation];
    }];
}



-(NSDictionary *)currentNewsInfo
{
    NSInteger index = self.index -1;
    if(index < 0)
    {
        index = self.textList.count -1;
    }
    return self.textList[index];
}


@end
