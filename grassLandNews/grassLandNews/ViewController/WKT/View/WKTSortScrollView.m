//
//  WKTSortScrollView.m
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WKTSortScrollView.h"
#import "ChannelButton.h"
#import "UIColor+Hex.h"

@interface WKTSortScrollView()
{
    //下面可能根据不同分辨率屏幕进行不同参数的设置
    //按钮的宽度
    NSInteger _buttonW;
    //按钮的高度
    NSInteger _buttonH;
    //按钮距离屏幕边框的距离
    NSInteger _buttonMarginForDevice;
    //按钮列数
    NSInteger _totalCol;
    //选中的view的起始位置
    CGPoint originPoint;
    //选中View最后需要移动到的位置
    CGPoint endPoint;
    BOOL isCanMove;
}
@property (nonatomic, strong) UIView *iTopView;
@property (nonatomic, strong) UIButton *iSelectBtn;

//一开始的频道数组（主要用于判断是否进行了频道编辑）
@property (nonatomic,strong) NSMutableArray  *originalChannelDataArray;
//进行编辑频道的btn数组
@property (nonatomic,strong) NSMutableArray  *selectButtonArray;
//已选频道的数据数组，根据沙盒文件查找
@property (nonatomic,strong) NSMutableArray  *selectChannelDataArray;
//是否编辑按钮
@property (nonatomic,assign) BOOL isEdit;
//占位图
@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) NSMutableArray *tagArr;
@end

@implementation WKTSortScrollView

#pragma mark - public
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isCanMove = YES;
        self.tagArr = [NSMutableArray array];
        [self initData];
        [self initSet];
        [self setChannelButton];
        [self editButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recoverData:) name:@"recoverDataNotification" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void)initData{
    
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    NSString *name = [NSString stringWithFormat:@"%@channelDatas",currentUser.username];
//

//    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@""];
    self.selectChannelDataArray = [[NSMutableArray alloc] initWithArray:[[ChannelManager shareInstance] getChannels]];
    self.originalChannelDataArray = [[NSMutableArray alloc] initWithArray:[[ChannelManager shareInstance] getChannels]];
    self.imageViewArr = [NSMutableArray array];
}

- (void)initSet{
    self.isEdit = NO;
    self.userInteractionEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = KColorAppMain;
    self.alpha = 0.96;
}

#pragma mark - 设置频道button
-(void)setChannelButton
{
    //1.添加已选频道按钮
    for (NSInteger i = 0; i < self.selectChannelDataArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:@"top_navigation_cross"]];
        
        [self addSubview:imageView];
        [self.imageViewArr addObject:imageView];
        
        
        NSDictionary *dict = self.selectChannelDataArray[i];
        ChannelButton  *btn = [[ChannelButton alloc] init];
        btn.text = [dict objectForKey:@"NodeName"];
        //添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        [btn addGestureRecognizer:pan];
        [pan addTarget:self action:@selector(panView:)];
        
        [self.selectButtonArray addObject:btn];
        [self addSubview:btn];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(channelButtonClick:)];
        [btn addGestureRecognizer:tap];
    }
    //更新位置
    [self updateAllFrameWithAnimationsDuration:0];
}

#pragma mark - 频道按钮的点击事件
/**
 *  频道按钮的点击事件
 */
-(void)channelButtonClick:(UITapGestureRecognizer *) tap{
    ChannelButton *btn = (ChannelButton *)tap.view;
    self.wBlock(btn.text);
    
    if([self.selectButtonArray containsObject:btn])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChannelChanged"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 更新所有控件的位置,是否有动画
/**
 *  更新所有控件的位置
 */
-(void)updateAllFrameWithAnimationsDuration:(NSTimeInterval) timeInterval
{
    [UIView animateWithDuration:timeInterval animations:^{
        //1.设置topView的Frame
        self.iTopView.frame = CGRectMake(0, 0, self.frame.size.width,44);//宽高需要稍后改变
        //2.设置selectButton的Frame buttonMargin
        CGFloat marginX = (kScreenWidth - self.buttonMarginForDevice * 2 - self.totalCol * self.buttonW) / (self.totalCol - 1);
        CGFloat marginY = 21;
        CGFloat selectButtonStartY = CGRectGetMaxY(self.iTopView.frame) + 25;//选择频道的Y值得开始位置
        for (NSInteger i = 0; i < self.selectButtonArray.count; i++) {
            NSInteger row = i / self.totalCol;
            NSInteger col = i % self.totalCol;
            CGFloat x = self.buttonMarginForDevice + (self.buttonW + marginX) * col;
            CGFloat y = selectButtonStartY + (self.buttonH + marginY) * row;
            ChannelButton *channeButton = self.selectButtonArray[i];
            channeButton.frame = CGRectMake(x, y, self.buttonW, self.buttonH);
            
            UIImageView *imageView = [self.imageViewArr objectAtIndex:i];
            imageView.frame = channeButton.frame;
        }
    }];
}

#pragma mark - 根据不同分辨率屏幕进行不同参数的设置

-(NSInteger)buttonW{
    _buttonW = 90;
    return _buttonW;
}

-(NSInteger)buttonH{
    _buttonH = 35;
    return _buttonH;
}

-(NSInteger)buttonMarginForDevice{
    
    UIWindow *windwow = [UIApplication sharedApplication].keyWindow;
    if (windwow.frame.size.width==320.0) {
        _buttonMarginForDevice = kEdgeInsetsLeft;
    }else{
        _buttonMarginForDevice = kEdgeInsetsLeft;
    }
    
    return _buttonMarginForDevice;
}

-(NSInteger)totalCol{
    _totalCol = 3;
    return _totalCol;
}

#pragma mark - 懒加载 自动生成的频道按钮
-(NSMutableArray *)selectButtonArray{
    if (_selectButtonArray == nil) {
        _selectButtonArray = [NSMutableArray array];
    }
    return _selectButtonArray;
}

#pragma mark - UITouch

- (void)editButton{
    self.iSelectBtn.selected = !self.iSelectBtn.selected;
    self.isEdit = YES;
    
    ChannelButton *channelButton = (ChannelButton *)self.selectButtonArray[0];
    channelButton.userInteractionEnabled = !channelButton.isUserInteractionEnabled;
}

#pragma mark - 拖拽事件响应方法
/**
 *  频道拖拽事件
 */
-(void)panView:(UIPanGestureRecognizer *) pan
{
    ChannelButton *SelectBtn =(ChannelButton *)pan.view;
    
    if (![self.selectButtonArray containsObject:SelectBtn] || !self.isEdit) return;
    if (pan.state == UIGestureRecognizerStateBegan ) {
        if (self.tagArr.count!=0) {
            isCanMove = NO;
            return;
        }else{
            [self.tagArr addObject:SelectBtn];
        }
        originPoint  = SelectBtn.center;
        endPoint = originPoint;
        SelectBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        SelectBtn.exclusiveTouch = YES;
        [self bringSubviewToFront:SelectBtn];
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        if (isCanMove==NO) {
            return;
        }
        CGPoint ChangePoint = [pan translationInView:pan.view];
        CGPoint temp = SelectBtn.center;
        temp.x += ChangePoint.x;
        temp.y += ChangePoint.y;
        SelectBtn.center = temp;
        [pan setTranslation:CGPointZero inView:pan.view];
        NSInteger index = [self indexOfPoint:SelectBtn.center withButton:SelectBtn];
        //第一个不可动
        if (index <=0) {
            return;
        }else{
            ChannelButton *button = self.selectButtonArray[index];
            endPoint = button.center;
            [self.selectButtonArray removeObject:SelectBtn];//先移除btn
            [self.selectButtonArray insertObject:SelectBtn atIndex:index];
            [self updateFrameSelect:index];
        }
        
    }else if(pan.state == UIGestureRecognizerStateEnded){
        ChannelButton * btn = [self.tagArr firstObject];
        if (btn==SelectBtn) {
            isCanMove = YES;
            [self.tagArr removeAllObjects];
        }else{
            return;
        }
        SelectBtn.center = endPoint;
        SelectBtn.transform = CGAffineTransformIdentity;
    }else if(pan.state == UIGestureRecognizerStateCancelled){
        ChannelButton * btn = [self.tagArr firstObject];
        if (btn==SelectBtn) {
            isCanMove = YES;
            [self.tagArr removeAllObjects];
        }else{
            return;
        }
        SelectBtn.center = endPoint;
        SelectBtn.transform = CGAffineTransformIdentity;
    }
}

//判断拖拽到与第几个btn可以交换
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(ChannelButton *)btn
{
    for (NSInteger i = 0;i<self.selectButtonArray.count;i++)
    {
        ChannelButton *button = self.selectButtonArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

-(void)updateFrameSelect:(NSInteger)index
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ChannelChanged"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CGFloat marginX = (kScreenWidth - self.buttonMarginForDevice * 2 - self.totalCol * self.buttonW) / (self.totalCol - 1);
    CGFloat marginY = 21;
    CGFloat selectButtonStartY = CGRectGetMaxY(self.iTopView.frame) + 25;//选择频道的Y值得开始位置
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i = 0; i < self.selectButtonArray.count; i++) {
            if (i == index) {
                continue;
            }
            NSInteger row = i / self.totalCol;
            NSInteger col = i % self.totalCol;
            CGFloat x = self.buttonMarginForDevice + (self.buttonW + marginX) * col;
            CGFloat y = selectButtonStartY + (self.buttonH + marginY) * row;
            ChannelButton *channeButton = self.selectButtonArray[i];
            channeButton.frame = CGRectMake(x, y, self.buttonW, self.buttonH);
        }
    }];
    [self saveChannelData];
}
//每次更改都需要更新文件
- (void)saveChannelData{
    NSMutableArray *newChannelArr = [NSMutableArray array];
    NSMutableArray *selectChannelArray = [[NSMutableArray alloc] init];
    for (ChannelButton *btn in self.selectButtonArray) {
        [selectChannelArray addObject:btn.text];
    }
    
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    NSString *name = [NSString stringWithFormat:@"%@channelDatas",currentUser.username];
    NSMutableArray *oldChannelArr = [NSMutableArray arrayWithArray:[[ChannelManager shareInstance] getChannels]];
    for (int i=0; i<selectChannelArray.count; i++) {
        NSString *channelText = [selectChannelArray objectAtIndex:i];
        for (int j=0; j<oldChannelArr.count; j++) {
            NSDictionary *dict = [oldChannelArr objectAtIndex:j];
            NSString *oldText = [dict objectForKey:@"NodeName"];
            if ([channelText isEqualToString:oldText]) {
                [newChannelArr addObject:dict];
                break;
            }
        }
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:newChannelArr forKey:@""];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [[ChannelManager shareInstance] updateChannels:newChannelArr];
    
    
}

#pragma mark - NSNotificaiton

- (void)recoverData:(id)notification{
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    NSString *name = [NSString stringWithFormat:@"%@channelDatas",currentUser.username];
    [[NSUserDefaults standardUserDefaults] setObject:self.originalChannelDataArray forKey:@""];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
