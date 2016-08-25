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
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)KDCycleBannerView *topView;
@property (nonatomic,strong) NSArray *bannerArr;
@property(nonatomic, strong)UIView *rollViewBackGround;
@property(nonatomic, strong)MutilTextLabel *rollLabel;
@property(nonatomic, strong)NSMutableArray *newsList;
@property(nonatomic, strong)NSMutableArray *channelList;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, assign)NSInteger totalPage;
@end

@implementation NewsSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsList = [NSMutableArray arrayWithCapacity:1];
    self.channelList = [NSMutableArray arrayWithCapacity:1];
    [self initBanner];
    [self setupViews];
    
    NSNumber *cycleNumber = self.channelInfo[@"ImgNum"];
    if(cycleNumber.integerValue > 0)
    {
        [self requestCycleList];
    }
    NSNumber *rollNumber = self.channelInfo[@"rollNum"];
    if(rollNumber.intValue > 0)
    {
        [self requestRollNewsList];
    }
    if([self isMainPage])
    {
        [self requestHome];
    }
    else
    {
        [self requestNewsList];
        [self setupRefresh];
    }
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
    
    NSNumber *cycleNumber = self.channelInfo[@"ImgNum"];
    if(cycleNumber.integerValue > 0)
    {
        [self initTopCycleView];
    }
    NSNumber *rollNumber = self.channelInfo[@"rollNum"];
    
    if(rollNumber.intValue > 0)
    {
        [self initRollView];
    }
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
        if(_rollViewBackGround)
        {
            make.top.mas_equalTo(_rollViewBackGround.mas_bottom).with.offset(5);
        }
        else if(_topView)
        {
            make.top.mas_equalTo(_topView.mas_bottom).with.offset(5);
        }
        else
        {
            make.top.mas_equalTo(0);
        }
        make.height.mas_equalTo([self getTablewHight]);
    }];
    
    
}

-(CGFloat)getTablewHight
{
//    return 2*KSectionHeaderHight + 3*(2*100 + 160);
    if([self isMainPage])
    {
        return KSectionHeaderHight*self.channelList.count + 100.0f * self.newsList.count;
    }
    
    return  100.0f * self.newsList.count;

}


-(void)reloadAllDatas
{
    NSNumber *cycleNumber = self.channelInfo[@"ImgNum"];
    if(cycleNumber.integerValue > 0)
    {
        [self requestCycleList];
    }
    NSNumber *rollNumber = self.channelInfo[@"rollNum"];
    
    if(rollNumber.intValue > 0)
    {
        [self requestRollNewsList];
    }
    if(![self isMainPage])
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
    if([self isMainPage])
    {
        return self.channelList.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self isMainPage])
    {
    
        return [self rowCountBySection:section];
    }
    
    return self.newsList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *newsInfo = nil;
    if([self isMainPage])
    {
        newsInfo = [self newsBySection:indexPath.section row:indexPath.row];
    }
    else
    {
        newsInfo = self.newsList[indexPath.row];
    }
    
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
    if([self isMainPage])
    {
        return KSectionHeaderHight;
    }
    
    return 0.0f;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(![self isMainPage])
    {
        return nil;
    }
    
    NSDictionary *nodeInfo = self.channelList[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, KSectionHeaderHight);
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = KColorAppMain;
    [headerView addSubview:lineView];
    lineView.frame = CGRectMake(0, 0, kScreenWidth, 1);
    
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    sectionTitleLabel.font = kFontNewsSubTitle;
    sectionTitleLabel.textColor = KColorAppMain;
    sectionTitleLabel.text = nodeInfo[@"NodeName"];
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
    NSDictionary *newsInfo = nil;
    if([self isMainPage])
    {
        newsInfo = [self newsBySection:indexPath.section row:indexPath.row];
    }
    else
    {
        newsInfo = self.newsList[indexPath.row];
    }
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
    NSNumber *nodeIdNumber = nil;
    if([self isMainPage])
    {
        nodeIdNumber = @(0);
    }
    else
    {
        nodeIdNumber = self.channelInfo[@"NodeID"];
    }
    [newsM requestCycleListByNodeId:nodeIdNumber.integerValue onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
    NSNumber *nodeIdNumber = nil;
    if([self isMainPage])
    {
        nodeIdNumber = @(0);
    }
    else
    {
        nodeIdNumber = self.channelInfo[@"NodeID"];
    }
    [newsM requestRollListByNodeId:nodeIdNumber.integerValue onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
    self.currentPage = 1;
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    NSNumber *nodeId = self.channelInfo[@"NodeID"];
    [newsM requestNewsListByPage:self.currentPage nodeId:nodeId.intValue keyword:nil ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.integerValue > 0)
        {
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:responseObject[@"data"][@"data"]];
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([self getTablewHight]);
            }];
            [self.tableView reloadData];
            NSNumber *totalPage = responseObject[@"data"][@"totalPage"];
            self.totalPage = totalPage.integerValue;
            self.currentPage ++;
            self.scrollView.footer.hidden = self.currentPage > self.totalPage?YES:NO;
        }
        [self.scrollView.header endRefreshing];
        
    }];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    @weakify(self);
    self.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestNewsList];
    }];
    
    self.scrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestNextPage];
    }];
    
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) self.scrollView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
}


-(void)requestNextPage
{
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    NSNumber *nodeId = self.channelInfo[@"NodeID"];
    [newsM requestNewsListByPage:self.currentPage nodeId:nodeId.intValue keyword:nil ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.integerValue > 0)
        {
            [self.newsList addObjectsFromArray:responseObject[@"data"][@"data"]];
            [UIView animateWithDuration:0.3f animations:^{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([self getTablewHight]);
                }];
                [self.tableView reloadData];
            }];
            self.currentPage ++;
            self.scrollView.footer.hidden = self.currentPage > self.totalPage?YES:NO;
        }
        [self.scrollView.footer endRefreshing];
    }];
}


-(void)requestHome
{
    NewsManager *newsM = [[NewsManager alloc] init];
    @weakify(self);
    [newsM requestHomeNewsList:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(status.integerValue > 0)
        {
            [self.newsList removeAllObjects];
            [self.channelList removeAllObjects];
            [self.newsList addObjectsFromArray:responseObject[@"data"][@"allArticle"]];
            [self.channelList addObjectsFromArray:responseObject[@"data"][@"allType"]];
            [UIView animateWithDuration:0.3f animations:^{
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([self getTablewHight]);
                }];
                [self.tableView reloadData];
            }];
        }
        
        
    }];

}

-(BOOL)isMainPage
{
    NSNumber *NodeId = self.channelInfo[@"NodeID"];
    if(NodeId.intValue == -2)
    {
        return YES;
    }
    return NO;
}

-( NSInteger)rowCountBySection:(NSInteger)section
{
    NSDictionary *channelInfo = self.channelList[section];
    NSNumber *nodeId = channelInfo[@"NodeID"];
    __block NSInteger count = 0;
    [self.newsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *newsInfo = (NSDictionary *)obj;
        NSNumber *newsNodeId = newsInfo[@"NodeID"];
        if(newsNodeId.integerValue == nodeId.integerValue)
        {
            count ++;
        }
    }];
    
    
    return count;
}


-(NSDictionary *)newsBySection:(NSInteger)section row:(NSInteger)row
{
    NSDictionary *channelInfo = self.channelList[section];
    NSNumber *nodeId = channelInfo[@"NodeID"];
    __block NSInteger count = 0;
    __block NSDictionary *selectedNewsInfo = nil;
    [self.newsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *newsInfo = (NSDictionary *)obj;
        NSNumber *newsNodeId = newsInfo[@"NodeID"];
        if(newsNodeId.integerValue == nodeId.integerValue)
        {
            if(count == row)
            {
                selectedNewsInfo = newsInfo;
                *stop = YES;
            }
            count ++;
        }
    }];
    
    return selectedNewsInfo;
}


@end
