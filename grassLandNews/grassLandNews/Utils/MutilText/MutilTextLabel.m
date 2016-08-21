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

@end

@implementation MutilTextLabel

-(id)init
{
    self = [super init];
    if(self)
    {
        _index = 0;
        _interval = 2.0f;
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
    
    NSTimeInterval period = self.interval; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        [self updateText];
    });
    
    dispatch_resume(_timer);
    
}

-(void)updateText
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = self.textList[self.index];
        self.text = dic[@"Title"];
        [UIView animateWithDuration:0.3f animations:^{
            [self setNeedsLayout];
        }];
        self.index ++;
        if(self.index >= self.textList.count)
        {
            self.index = 0;
        }        
    });
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
