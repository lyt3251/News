//
//  WXYNewListViewController.m
//  TXChatParent
//
//  Created by shengxin on 16/4/15.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WXYNewListViewController.h"
#import "UIColor+Hex.h"
#import "WXYNewSubListViewController.h"
#import "WKTSortViewController.h"
#import "WXYSearchViewController.h"
#import "TXWebViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

#define ViewPageTabHeight 40.0
#define viewBackgroundColor [UIColor colorWithHexStr:@"f4f5f6"]
#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending

@interface WXYNewListViewController ()<ViewPagerDataSource, ViewPagerDelegate>
{
    BOOL isToPushSearch;
    BOOL isToSelectChannel;//跳转到指定的channel
}
@property (nonatomic, strong) NSMutableArray *iChannleArr;
@property (nonatomic, strong) NSMutableArray *iViewControllersArray;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *iShadowView;
@end

@implementation WXYNewListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

/**
 *  根据channelID得到位置
 */
- (NSInteger)getIndexChannelFromName:(NSString*)aChannelID{
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
//    NSArray *array =  [[NSUserDefaults standardUserDefaults] objectForKey:name];
    NSArray *array = [[ChannelManager shareInstance] getChannels];
    NSInteger i = 0;
    for(NSDictionary *dict in array){
        NSString *channelID = [dict objectForKey:@"channelId"];
        if ([aChannelID isEqualToString:channelID]) {
            return i;
        }
        i++;
    }
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    [self initSet];
    [self initShadwView];
    [self initChannelData];
    self.customNavigationView.backgroundColor = [UIColor whiteColor];
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_leftVCIcon"] forState:UIControlStateNormal];
//    [self setNeedsReloadColors];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sortPushSearchController];//排序搜索页自动跳转
    [self selectChannelIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self presentLeftMenuViewController:sender];
    }
}
#pragma mark - init
- (void)createCustomNavBar{
    [super createCustomNavBar];
    
    UIImageView *appLogo = [[UIImageView alloc] init];
    appLogo.image = [UIImage imageNamed:@"Main_AppIcon"];
    [self.customNavigationView addSubview:appLogo];
    CGFloat topMargin = 20 + (self.customNavigationView.maxY - 20 - appLogo.image.size.height)/2;
    
    [appLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(appLogo.image.size);
        make.top.mas_equalTo(topMargin);
    }];
    
    
    [self.btnRight setImage:[UIImage imageNamed:@"Main_Search"]  forState:UIControlStateNormal];
    [self.btnRight addTarget:self action:@selector(searchPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageNamed:@"Main_Add"];
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.tag = 0x10000+1;
    if (IOS_VERSION_7) {
        [sortBtn setFrame:CGRectMake(self.view.frame.size.width-14-image.size.width,74+(ViewPageTabHeight-40)/2, image.size.width+14,40)];
        [sortBtn setBackgroundColor: KColorAppMain];
    }else{
        [sortBtn setBackgroundColor:KColorAppMain];
        [sortBtn setFrame:CGRectMake(self.view.frame.size.width-14-image.size.width,44+(ViewPageTabHeight-40)/2, image.size.width+14,40)];
    }

    //    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(-(),0,0,0);// CGFloat top, left, bottom, right
    [sortBtn setImage:image forState:UIControlStateNormal];
    [sortBtn setImage:image forState:UIControlStateHighlighted];
    [sortBtn addTarget:self action:@selector(sortBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortBtn];
    
//    UIView *maskView = [[UIView alloc] init];
//    maskView.backgroundColor = RGBACOLOR(0x44, 0x99, 0x69, 0.6f);
//    maskView.tag = 0x10000;
//    [self.view addSubview:maskView];
//    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(sortBtn);
//        make.right.mas_equalTo(sortBtn.mas_left);
//        make.width.mas_equalTo(10);
//        make.centerY.mas_equalTo(sortBtn);
//    }];
    
}

- (void)initSet{
    self.dataSource = self;
    self.delegate = self;
    isToPushSearch = NO;//判断栏目编辑搜索按钮按下后自动push到搜索页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortPushToSearchController:) name:@"SortPushToSearchControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndex:) name:@"SelectChannelIndexNotification" object:nil];
}

- (void)initShadwView{
    self.iShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customNavigationView.maxY, self.view.frame.size.width, self.view.frame.size.height)];
//    self.iShadowView.backgroundColor = self.view.backgroundColor;
    self.iShadowView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.iShadowView];
}

- (void)initChannelData{
    self.iChannleArr = [NSMutableArray array];
    self.iViewControllersArray = [NSMutableArray array];
    __weak WXYNewListViewController *weself = self;
//    [[TXChatClient sharedInstance].txJsbMansger fetchTagsWithTagType:TXPBTagTypeTagBaseParent onCompleted:^(NSError *error, NSArray *tags) {
//        if (error) {
//            [weself showFailedHudWithError:error];
//            [weself reloadData];
//            return;
//        }
//        if(tags.count==0){
//            [weself reloadData];
//            return ;
//        }
//        self.iShadowView.hidden = YES;
//        self.shadowView.hidden = YES;
//        [weself checkNewChannel:tags];
//        for (int i=0; i<weself.iChannleArr.count; i++) {
//            WXYNewSubListViewController *w = [[WXYNewSubListViewController alloc] initWithNibName:nil bundle:nil];
//            NSDictionary *dict = [weself.iChannleArr objectAtIndex:i];
//            NSInteger channelId = [[dict objectForKey:@"channelId"] integerValue];
//            [w loadData:channelId];
//            [weself.iViewControllersArray addObject:w];
//        }
//        //跳转到制定channel
//        [self  selectChannelIndex];
//        [weself reloadData];
//    }];
    
    self.iShadowView.hidden = YES;
    self.shadowView.hidden = YES;
//        [self checkNewChannel:tags];
    
    
    self.iChannleArr = [NSMutableArray arrayWithArray:[[ChannelManager shareInstance] getChannels]];
    
    for (int i=0; i<weself.iChannleArr.count; i++) {
        WXYNewSubListViewController *w = [[WXYNewSubListViewController alloc] initWithNibName:nil bundle:nil];
        NSDictionary *dict = [weself.iChannleArr objectAtIndex:i];
        NSInteger channelId = [[dict objectForKey:@"channelId"] integerValue];
        [w loadData:channelId];
        [weself.iViewControllersArray addObject:w];
    }
    //跳转到制定channel
    [self  selectChannelIndex];
    [weself reloadData];
    
    
}
/**
 *  排序页跳转到搜索页
 */
- (void)sortPushSearchController{
    if (isToPushSearch==YES) {
        isToPushSearch = NO;
        [self searchPress:nil];
    }
}
/**
 *  跳转到指定的栏目
 */
- (void)selectChannelIndex{
    __weak WXYNewListViewController *weself = self;
    if (isToSelectChannel==YES) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weself selectTabAtIndex:weself.selectIndex];
        });
        isToSelectChannel = NO;
    }
}

//比较channel是否更新
- (void)checkNewChannel:(NSArray*)aNewArr{
    NSMutableArray *arrayNew = [NSMutableArray array];
//    TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
    NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
     NSArray *arrayOld = [[NSUserDefaults standardUserDefaults] objectForKey:name];
    if(arrayOld.count!=0){
        //如果更新channelName
//        for (int i=0; i<arrayOld.count; i++) {
//            
//            NSDictionary *dictOld = [arrayOld objectAtIndex:i];
//            NSInteger oldId = [[dictOld objectForKey:@"channelId"] integerValue];
//            NSString *oldName = [dictOld objectForKey:@"channelName"];
//            for (int j=0; j<aNewArr.count; j++) {
//                TXPBTag *modelNew = [aNewArr objectAtIndex:j];
//                if (oldId==modelNew.id) {
//                    if ([oldName isEqualToString:modelNew.name]) {
//                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                        [dict setObject:[NSString stringWithFormat:@"%ld",(long)oldId] forKey:@"channelId"];
//                        [dict setObject:oldName forKey:@"channelName"];
//                        [arrayNew addObject:dict];
//                        break;
//                    }else{
//                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                        [dict setObject:[NSString stringWithFormat:@"%lld",modelNew.id] forKey:@"channelId"];
//                        [dict setObject:modelNew.name forKey:@"channelName"];
//                        [arrayNew addObject:dict];
//                        break;
//                    }
//                }
//            }
//        }
        
        //如果新添加了channel
//        if(arrayOld.count!=aNewArr.count){
//            for (int i=0; i<aNewArr.count; i++) {
//                TXPBTag *modelNew = [aNewArr objectAtIndex:i];
//                int k = 0;
//                for (int j=0; j<arrayOld.count; j++) {
//                    NSDictionary *modelOld = [arrayOld objectAtIndex:j];
//                    NSInteger modelOldId = [[modelOld objectForKey:@"channelId"] integerValue];
//                    if (modelNew.id==modelOldId) {
//                        k = 1;
//                        break;
//                    }
//                }
//                if (k==0) {
//                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                    [dict setObject:[NSString stringWithFormat:@"%lld",modelNew.id] forKey:@"channelId"];
//                    [dict setObject:modelNew.name forKey:@"channelName"];
//                    [arrayNew addObject:dict];
//                }
//            }
//        }
       
//        TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
        NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
        [[NSUserDefaults standardUserDefaults] setObject:arrayNew forKey:name];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.iChannleArr = [[NSMutableArray alloc] initWithArray:arrayNew];
    }else{
        
//        for (int i=0; i<aNewArr.count; i++) {
//            TXPBTag *modelNew = [aNewArr objectAtIndex:i];
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            [dict setObject:[NSString stringWithFormat:@"%lld",modelNew.id] forKey:@"channelId"];
//            [dict setObject:modelNew.name forKey:@"channelName"];
//            [arrayNew addObject:dict];
//        }
        
        self.iChannleArr = [[NSMutableArray alloc] initWithArray:arrayNew];
        
//        TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
        NSString *name = [NSString stringWithFormat:@"%@channelDatas",@""];
        [[NSUserDefaults standardUserDefaults] setObject:arrayNew forKey:name];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return ViewPageTabHeight;
        case ViewPagerOptionTabWidth://间隔
            return (15*4+15*2);
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor clearColor];
        case ViewPagerTabsView:
            return KColorAppMain;
        case ViewPagerContent:
            return viewBackgroundColor;
        default:
            return color;
    }
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    if (self.iChannleArr.count==0) {
        return 0;
    }
    return self.iChannleArr.count;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = kColorClear;
    UIFont *font = [UIFont systemFontOfSize:15.0];
    [label setFont:font];
    NSDictionary *dict = [self.iChannleArr objectAtIndex:index];
    label.text = [dict objectForKey:@"channelName"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kColorWhite;//未点击颜色;
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    __weak WXYNewListViewController *weself = self;
    WXYNewSubListViewController *v = [self.iViewControllersArray objectAtIndex:index];
//    v.tBlock = ^(TXPBArticleAbstract *model){
//        TXWebViewController *detailVc = [[TXWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@&pf=WJY",model.detailUrl ]];
//        detailVc.titleStr = @"";
//        detailVc.requireShare = YES;
//        detailVc.isClearPush = YES;
//        [detailVc setShareUrl:model.shareUrl];
//        [weself.navigationController pushViewController:detailVc animated:YES];
//    };
    return v;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index{
    NSLog(@"%lu",(unsigned long)index);
}

#pragma mark - UITouch
- (void)sortBtn:(id)sender{
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if( reach.isReachable==NO){
        [self showFailedHudWithTitle:@"网络连接失败"];
        return;
    }
    
    __weak WXYNewListViewController *weself = self;
    NSDictionary *channelDict = [self.iChannleArr objectAtIndex:self.activeTabIndex];
    //截取一张图片
    UIImage *image = [self getImage];
    WKTSortViewController *s = [[WKTSortViewController alloc] init];
    s.bgContentImage = image;
    s.iSelectId =  [[channelDict objectForKey:@"channelId"] integerValue];
    s.delegate = ^(NSInteger selectIndex,NSArray *array){
        [weself.iChannleArr removeAllObjects];
        weself.iChannleArr = [[NSMutableArray alloc] initWithArray:array];
        [weself.iViewControllersArray removeAllObjects];
        for (int i=0; i<weself.iChannleArr.count; i++) {
            WXYNewSubListViewController *w = [[WXYNewSubListViewController alloc] initWithNibName:nil bundle:nil];
            NSDictionary *dict = [weself.iChannleArr objectAtIndex:i];
            NSInteger channelId = [[dict objectForKey:@"channelId"] integerValue];
            [w loadData:channelId];
            [weself.iViewControllersArray addObject:w];
        }
        [weself reloadData];

        if (selectIndex!=-1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weself selectTabAtIndex:selectIndex];
            });
        }
    };
    [self.navigationController pushViewController:s animated:NO];
}

- (void)searchPress:(id)sender{
    WXYSearchViewController *v = [[WXYSearchViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark - 截图
- (UIImage*)getImage{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.frame.size, YES, 0.0);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - NSNotification
- (void)sortPushToSearchController:(id)notification{
    isToPushSearch = YES;
}

- (void)selectIndex:(id)notification{
    isToSelectChannel = YES;
    self.selectIndex = [[[notification userInfo] objectForKey:@"data"] integerValue];
}

@end
