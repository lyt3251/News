//
//  NewsSubListViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsSubListViewController.h"
#import "KDCycleBannerView.h"

@interface NewsSubListViewController ()<KDCycleBannerViewDataource, KDCycleBannerViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)KDCycleBannerView *topView;
@property (nonatomic,strong) NSArray *bannerArr;
@end

@implementation NewsSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBanner];
    [self setupViews];
}


-(void)setupViews
{
    [self initTopCycleView];

}


//初始化轮播条
- (void)initTopCycleView{
    CGFloat width = kScreenWidth;
    CGFloat height = kScreenWidth * 420/750;
    
    _topView = [[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _topView.delegate = self;
    _topView.datasource = self;
    _topView.continuous = YES;
    _topView.autoPlayTimeInterval = 3.f;
    [self.view addSubview:_topView];
}


-(void)initBanner
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for(NSInteger i = 0; i < 5; i++)
    {
        NSDictionary *dic = @{@"imgUrl":@"http://n.sinaimg.cn/news/20160803/W3zn-fxunyxy6433570.jpg", @"obj":@(i)};
        [array addObject:dic];
    }
    self.bannerArr = [NSArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - KDCycleBannerViewDataource methods
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return _bannerArr;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFill;
}
- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"banner.jpg"];
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"banner.jpg"];
}
- (id)imageSourceForContent:(id)content
{
    NSDictionary *dic = (NSDictionary *)content;
    NSString *urlString = dic[@"imgUrl"];
    //对url进行encode编码，避免url中出现中文或者其他非法字符时导致转成NSURL为nil的问题
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *imgStr = [urlString getFormatPhotoUrl:_topView.width_ hight:_topView.height_];
    //    NSString *imgStr = [urlString getFormatPhotoUrl:_topView.width_ hight:_topView.height_];
    //    return imgStr;
    return urlString;
}

-(NSString *)titleAtIndex:(NSUInteger )index;
{
    return [NSString stringWithFormat:@"测试标题测试标题：%@", @(index)];
}

#pragma mark - KDCycleBannerViewDelegate methods
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
    
}




@end
