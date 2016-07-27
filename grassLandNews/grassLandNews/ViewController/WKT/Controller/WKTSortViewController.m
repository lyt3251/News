//
//  WKTSortViewController.m
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WKTSortViewController.h"
#import "WKTSortScrollView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "WKTSortScrollView.h"
#import "AppDelegate.h"
#import "UIColor+Hex.h"

#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending

@interface WKTSortViewController ()
{
    BOOL isAutoPressRightButton;
}

@property (nonatomic, strong) UIButton *iCloseBtn;
@property (nonatomic, strong) WKTSortScrollView *iSortBtnScrollView;
@property (nonatomic, strong) UIView *iTopView;

@end

@implementation WKTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createCustomNavBar];
    [self initSet];
    [self initTopView];
    [self initSortScrollView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self autoUpandDownAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property
/**
 *  初始化背景截图
 */
- (void)setBgContentImage:(UIImage *)bgContentImage{
    _bgContentImage = bgContentImage;
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:_bgContentImage];
    backgroundImageView.frame =CGRectMake(0.0,0, kScreenWidth,kScreenHeight);
    [self.view insertSubview:backgroundImageView belowSubview:self.iSortBtnScrollView];
}

#pragma mark - init
- (void)createCustomNavBar{
    [super createCustomNavBar];
    
    self.fd_interactivePopDisabled = YES;//禁止手势返回
    self.titleStr = @"微学园";
    [self.btnLeft addTarget:self action:@selector(popToRootController:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight setImage:[UIImage imageNamed:@"wxySearch"]  forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(searchPress:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initSet{
    isAutoPressRightButton = YES;
}

- (void)initTopView{
    CGFloat y = 0;
    if (IOS_VERSION_7) {
        y = 64;
    }else{
        y = 44;
    }
    self.iTopView = [[UIView alloc] initWithFrame:CGRectMake(0,y, self.view.frame.size.width,37)];
    self.iTopView.backgroundColor = [UIColor colorWithHexStr:@"f4f5f6"];
    self.iTopView.alpha = 0.97;
    [self.view addSubview:self.iTopView];
    
    CGFloat x;
    UIWindow *windwow = [UIApplication sharedApplication].keyWindow;
    if (windwow.frame.size.width==320.0) {
        x = 10.0;
    }else{
        x = 18.0;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x,(self.iTopView.frame.size.height-14.0)/2,100, 14)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"拖动排序";
    [label setFont:[UIFont systemFontOfSize:14.0]];
    label.textColor = [UIColor colorWithHexStr:@"999999"];
    [self.iTopView addSubview:label];
    
    self.iCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"wxyAdd"];
    [self.iCloseBtn setImage:image forState:UIControlStateNormal];
    [self.iCloseBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.iCloseBtn setFrame:CGRectMake(self.view.frame.size.width-image.size.width-10+2, (self.iTopView.frame.size.height-image.size.height)/2+1, image.size.width, image.size.height)];
    [self.iTopView addSubview:self.iCloseBtn];
}

- (void)initSortScrollView{
    __weak WKTSortViewController *weself = self;
    self.iSortBtnScrollView = [[WKTSortScrollView alloc] initWithFrame:CGRectMake(0,-kScreenHeight-self.iTopView.frame.size.height,kScreenWidth,kScreenHeight-64)];
    self.iSortBtnScrollView.wBlock = ^(NSString *selectName){
        NSLog(@"%@",selectName);
        //便利NSUserDefault中数组，找到对应channelId
//        TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
        NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:name];
        NSInteger index = [weself getChannelNameIndexFromChannelArr:selectName];
         weself.delegate(index,array);
        [weself.navigationController popViewControllerAnimated:YES];
    };
    [self.view insertSubview:self.iSortBtnScrollView belowSubview:self.iTopView];
    [self.view bringSubviewToFront:self.customNavigationView];
}
/**
 *  下拉或者上拉动画
 */
- (void)autoUpandDownAnimation{
    if (isAutoPressRightButton==YES) {
        //下拉动画
        [self closeBtn:self.iCloseBtn];
    }
}
/**
 *  返回selectId在数组中的位置
 */
- (NSInteger)getSelectIdIndexFromChannelArr:(NSString*)aSelectId{
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
    NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *selectId = [dict objectForKey:@"channelId"];
        if ([aSelectId isEqualToString:selectId]) {
            return i;
        }
    }
    return -1;
}

- (NSInteger)getChannelNameIndexFromChannelArr:(NSString*)aChannelName{
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
    NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *channelName = [dict objectForKey:@"channelName"];
        if ([aChannelName isEqualToString:channelName]) {
            return i;
        }
    }
    return -1;
}

#pragma mark - UITouch
- (void)closeBtn:(UIButton *)btn{
    isAutoPressRightButton = NO;
    btn.selected = !btn.selected;
    
    __weak WKTSortViewController *weself = self;
    if (btn.selected) {
        //下拉
        [UIView animateWithDuration:0.5 animations:^{
            if (IOS_VERSION_7) {
                self.iSortBtnScrollView.frame = CGRectMake(0.0,64.0+self.iTopView.frame.size.height, kScreenWidth, kScreenHeight-64-self.iTopView.frame.size.height);
            }else{
                self.iSortBtnScrollView.frame = CGRectMake(0.0,44.0+self.iTopView.frame.size.height, kScreenWidth, kScreenHeight-44-self.iTopView.frame.size.height);
            }
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, -M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            //图片旋转45度
            weself.iCloseBtn.transform = CGAffineTransformMakeRotation(M_PI/4);
        }];
    }else{
        //上拉
        [UIView animateWithDuration:0.1 animations:^{
            
            if (IOS_VERSION_7) {
                self.iSortBtnScrollView.frame = CGRectMake(0.0, -kScreenHeight-self.iTopView.frame.size.height, kScreenWidth, kScreenHeight-64-self.iTopView.frame.size.height);
            }else{
            self.iSortBtnScrollView.frame = CGRectMake(0.0, -kScreenHeight-self.iTopView.frame.size.height, kScreenWidth, kScreenHeight-44-self.iTopView.frame.size.height);
            }
        } completion:^(BOOL finished) {
//            TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
            NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:name];
            NSString *selectId = [NSString stringWithFormat:@"%li",(long)self.iSelectId];
            NSInteger index = [self getSelectIdIndexFromChannelArr:selectId];
            //返回index
            BOOL isChange = [[NSUserDefaults standardUserDefaults] boolForKey:@"ChannelChanged"];
            if (isChange==YES) {
                self.delegate(index,array);
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ChannelChanged"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self.navigationController popViewControllerAnimated:NO];
        }];
        
        //编辑按钮点击之后旋转效果
        [UIView animateWithDuration:0.1 animations:^{
            btn.transform = CGAffineTransformRotate(btn.transform, M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)popToRootController:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//必须加！防止不能立即pop 或者removeTarget
- (void)onClickBtn:(UIButton *)sender{
    
}

- (void)searchPress:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SortPushToSearchControllerNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
