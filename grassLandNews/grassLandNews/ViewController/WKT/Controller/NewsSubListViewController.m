//
//  NewsSubListViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsSubListViewController.h"
#import "KDCycleBannerView.h"
#import "NewsWithPhotoTableViewCell.h"
#import "NewsOnlyTextTableViewCell.h"
#import "NewsWithMultiPhotosTableViewCell.h"
#import "MutilTextLabel.h"
#import "NewsManager.h"
#import "NewsDetailViewController.h"

#define KSectionHeaderHight    30.0f

@interface NewsSubListViewController ()<KDCycleBannerViewDataource, KDCycleBannerViewDelegate, UIScrollViewDelegate,
                                        UITableViewDelegate, UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UIView *_contentView;//滚动条内的view;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)KDCycleBannerView *topView;
@property (nonatomic,strong) NSArray *bannerArr;
@property(nonatomic, strong)UIView *rollViewBackGround;
@property(nonatomic, strong)MutilTextLabel *rollLabel;
@property(nonatomic, strong)NSMutableArray *newsList;
@end

@implementation NewsSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsList = [NSMutableArray arrayWithCapacity:1];
    [self initBanner];
    [self setupViews];
    [self requestCycleList];
    [self requestRollNewsList];
    [self requestNewsList];
}


-(void)setupViews
{
    UIScrollView *scrollView = UIScrollView.new;
    _scrollView = scrollView;
    _scrollView.delegate = self;
    scrollView.backgroundColor = kColorBackground;
    [self.view addSubview:scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabBarHeight);
    }];
    UIView* contentView = UIView.new;
    [contentView setBackgroundColor:kColorBackground];
    _contentView = contentView;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    [self initTopCycleView];
    [self initRollView];
    [self initTableView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableView.mas_bottom);
    }];
    
    self.view.backgroundColor = RGBCOLOR(0xf6, 0xf6, 0xf6);
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
    [_contentView addSubview:_topView];
}

-(void)initBanner
{
    self.bannerArr = [NSArray array];;
}

-(void)initRollView
{
    _rollViewBackGround = [[UIView alloc] init];
    _rollViewBackGround.backgroundColor = kColorWhite;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RollViewTapEvent:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    //        tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    _rollViewBackGround.userInteractionEnabled = YES;
    [_rollViewBackGround addGestureRecognizer:tap];
    [_contentView addSubview:_rollViewBackGround];
    _rollViewBackGround.frame = CGRectMake(0, _topView.maxY, kScreenWidth, 30);
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Main_RollIcon"]];
    icon.userInteractionEnabled = YES;
    [_rollViewBackGround addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdgeInsetsLeft);
        make.centerY.mas_equalTo(_rollViewBackGround);
        make.size.mas_equalTo(icon.image.size);
    }];

    MutilTextLabel *rollLabel = [[MutilTextLabel alloc] init];
    rollLabel.font = kFontNewsSubTitle;
    rollLabel.textColor = kColorNewsRoll;
    rollLabel.userInteractionEnabled = YES;
//    rollLabel.textList = @[@"123", @"456"];
    rollLabel.interval = 5;
    [_rollViewBackGround addSubview:rollLabel];
    [rollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(5);
        make.centerY.mas_equalTo(_rollViewBackGround);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(_rollViewBackGround);
    }];
    self.rollLabel = rollLabel;
//    [rollLabel startShowTxt];
}


-(void)initTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.top.mas_equalTo(_rollViewBackGround.mas_bottom).with.offset(5);
        make.height.mas_equalTo([self getTablewHight]);
    }];
    
    
}

-(CGFloat)getTablewHight
{
//    return 2*KSectionHeaderHight + 3*(2*100 + 160);
    return  100.0f * self.newsList.count;

}


-(void)reloadAllDatas
{
    [self requestCycleList];
    [self requestRollNewsList];
    [self requestNewsList];
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
    NSDictionary *newsInfo = self.bannerArr[index];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

#pragma mark-- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *newsInfo = self.newsList[indexPath.row];
    NSString *picUrl = newsInfo[@"DefaultPicUrl"];
    if(picUrl.length > 0)
    {
        static NSString *identifier = @"NewsWithPhotoTableViewCell";
        NewsWithPhotoTableViewCell *newsWithPhotoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!newsWithPhotoCell)
        {
            newsWithPhotoCell = [[NewsWithPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [newsWithPhotoCell.titleLabel setTextByStr:newsInfo[@"Title"] WithSpace:7.0f];
        newsWithPhotoCell.subTitleLabel.text = newsInfo[@"NodeName"];
        
        [newsWithPhotoCell.rightImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"Left_Header"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"image:%@, error:%@, type:%@, url:%@", image, error, @(cacheType), imageURL);
        }];
        cell = newsWithPhotoCell;
    }
    else
    {
        static NSString *identifier = @"NewsOnlyTextTableViewCell";
        NewsOnlyTextTableViewCell *newsOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!newsOnlyTextCell)
        {
            newsOnlyTextCell = [[NewsOnlyTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        //        newsOnlyTextCell.titleLabel.text = @"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题";
        [newsOnlyTextCell.titleLabel setTextByStr:newsInfo[@"Title"] WithSpace:7.0f];
        newsOnlyTextCell.subTitleLabel.text = newsInfo[@"NodeName"];
        
        cell = newsOnlyTextCell;
    }
//    else if(indexPath.row == 2)
//    {
//        static NSString *identifier = @"NewsWithMultiPhotosTableViewCell";
//        NewsWithMultiPhotosTableViewCell *newsWithPhotos = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if(!newsWithPhotos)
//        {
//            newsWithPhotos = [[NewsWithMultiPhotosTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        newsWithPhotos.titleLabel.text = newsInfo[@"Title"];
//        newsWithPhotos.subTitleLabel.text = newsInfo[@"NodeName"];
//        NSString *photo = @"http://n.sinaimg.cn/news/20160803/6f47-fxupmws1661759.jpg";
//        newsWithPhotos.photos = @[photo, photo, photo];
//        
//        cell = newsWithPhotos;
//    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 2)
//    {
//        return 160.0f;
//    }
    return 100.0f;
}

#pragma mark-- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(section != 0)
//    {
//        return KSectionHeaderHight;
//    }
//    
    return 0.0f;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, KSectionHeaderHight);
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = KColorAppMain;
    [headerView addSubview:lineView];
    lineView.frame = CGRectMake(0, 0, kScreenWidth, 1);
    
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    sectionTitleLabel.font = kFontNewsSubTitle;
    sectionTitleLabel.textColor = KColorAppMain;
    sectionTitleLabel.text = @"通知公告";
    [headerView addSubview:sectionTitleLabel];
    [sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdgeInsetsLeft);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(0);
    }];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *newsInfo = self.newsList[indexPath.row];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


#pragma mark-- RollNewsTab
//点击图片后处理
-(void)RollViewTapEvent:(UITapGestureRecognizer*)recognizer
{
    NSDictionary *newsInfo = [self.rollLabel currentNewsInfo];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
    
}


-(void)requestCycleList
{
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    [newsM requestCycleList:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.intValue > 0)
        {
            self.bannerArr = responseObject[@"data"];
            [self.topView reloadDataWithCompleteBlock:^{
                
            }];
        }
    }];
}

-(void)requestRollNewsList
{
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    [newsM requestRollList:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.intValue > 0)
        {
            self.rollLabel.textList = responseObject[@"data"];
            [self.rollLabel startShowTxt];
        }
    }];
}


-(void)requestNewsList
{
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    NSNumber *nodeId = self.channelInfo[@"NodeID"];
    [newsM requestNewsListByPage:1 nodeId:nodeId.intValue keyword:nil ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.integerValue > 0)
        {
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:responseObject[@"data"]];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([self getTablewHight]);
            }];
            [self.tableView reloadData];
        }
    }];
}



@end
