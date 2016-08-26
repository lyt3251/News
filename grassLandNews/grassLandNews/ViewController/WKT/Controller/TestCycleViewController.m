//
//  TestCycleViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/26.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "TestCycleViewController.h"
#import "KDCycleBannerView.h"

@interface TestCycleViewController ()<KDCycleBannerViewDelegate, KDCycleBannerViewDataource>
@property(nonatomic, strong)KDCycleBannerView *topView;
@property (nonatomic,strong) NSArray *bannerArr;
@end

@implementation TestCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBanner];
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

    self.bannerArr = @[@{@"DefaultPicUrl" : @"http://www.grassland.gov.cn/grassland-new/UploadFiles/Article/2016/5/201653192752.jpg",
                         @"GeneralID" : @(8297),
                         @"NodeID" : @(1051),
                         @"NodeName" : @"测试测试测试",
                         @"Title" : @"测试测试测试"
                         },
                       @{@"DefaultPicUrl" : @"http://www.grassland.gov.cn/grassland-new/UploadFiles/Article/2016/5/201653192752.jpg",
                         @"GeneralID" : @(8297),
                         @"NodeID" : @(1051),
                         @"NodeName" : @"测试测试测试",
                         @"Title" : @"测试测试测试"
                         },
                       @{@"DefaultPicUrl" : @"http://www.grassland.gov.cn/grassland-new/UploadFiles/Article/2016/5/201653192752.jpg",
                         @"GeneralID" : @(8297),
                         @"NodeID" : @(1051),
                         @"NodeName" : @"测试测试测试",
                         @"Title" : @"测试测试测试"
                         },
                       @{@"DefaultPicUrl" : @"http://www.grassland.gov.cn/grassland-new/UploadFiles/Article/2016/5/201653192752.jpg",
                         @"GeneralID" : @(8297),
                         @"NodeID" : @(1051),
                         @"NodeName" : @"测试测试测试",
                         @"Title" : @"测试测试测试"
                         },
                       @{@"DefaultPicUrl" : @"http://www.grassland.gov.cn/grassland-new/UploadFiles/Article/2016/5/201653192752.jpg",
                         @"GeneralID" : @(8297),
                         @"NodeID" : @(1051),
                         @"NodeName" : @"测试测试测试",
                         @"Title" : @"测试测试测试"
                         }];

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
    return [UIImage imageNamed:@"MenuBackground"];
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"MenuBackground"];
}
- (id)imageSourceForContent:(id)content
{
    NSDictionary *dic = (NSDictionary *)content;
    NSString *urlString = dic[@"DefaultPicUrl"];
    //对url进行encode编码，避免url中出现中文或者其他非法字符时导致转成NSURL为nil的问题
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *imgStr = [urlString getFormatPhotoUrl:_topView.width_ hight:_topView.height_];
    //    NSString *imgStr = [urlString getFormatPhotoUrl:_topView.width_ hight:_topView.height_];
    //    return imgStr;
    return urlString;
}

-(NSString *)titleAtIndex:(NSUInteger )index;
{
    NSDictionary *dic = (NSDictionary *)self.bannerArr[index];
    NSString *urlString = dic[@"Title"];
    return urlString;
}

#pragma mark - KDCycleBannerViewDelegate methods
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index {
//    NSDictionary *newsInfo = self.bannerArr[index];
//    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
//    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

@end
