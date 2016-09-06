//
//  NewsNoticesViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/9/1.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsSpecialViewController.h"
#import "NewsWithPhotoTableViewCell.h"
#import "NewsOnlyTextTableViewCell.h"
#import "NewsManager.h"
#import "FavoritesManager.h"
#import "NewsDetailViewController.h"



@interface NewsSpecialViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *list;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, assign)NSInteger totalPage;

@end

@implementation NewsSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = RGBCOLOR(0x44, 0x99, 0x69);
    self.titleLb.textColor = [UIColor whiteColor];
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    self.titleStr = self.specialInfo[@"NodeName"];
    // Do any additional setup after loading the view.
    self.list = [NSMutableArray arrayWithCapacity:1];
    [self setupViews];
    [self requestList];
    [self setupRefresh];
}

-(void)setupViews
{
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(self.customNavigationView.maxY, 0, 0, 0));
    }];
    
}


-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

#pragma mark-- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *newsDic = self.list[indexPath.row];
    NSString *picUrl = newsDic[@"DefaultPicUrl"];
    
    if(picUrl.length > 0)
    {
        static NSString *identifier = @"NewsWithPhotoTableViewCell";
        NewsWithPhotoTableViewCell *newsWithPhotoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!newsWithPhotoCell)
        {
            newsWithPhotoCell = [[NewsWithPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [newsWithPhotoCell.titleLabel setTextByStr:newsDic[@"Title"] WithSpace:7.0f];
        newsWithPhotoCell.subTitleLabel.text = newsDic[@"NodeName"];
        newsWithPhotoCell.timeLabel.text = newsDic[@"InputTime"];
        
        
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
        
        
        [newsOnlyTextCell.titleLabel setTextByStr:newsDic[@"Title"] WithSpace:7.0f];
        newsOnlyTextCell.subTitleLabel.text = newsDic[@"NodeName"];
        newsOnlyTextCell.timeLabel.text = newsDic[@"InputTime"];        
        
        cell = newsOnlyTextCell;
    }
    
    return cell;
}

#pragma mark-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *newsInfo = self.list[indexPath.row];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}

-(void)requestList
{
    self.currentPage = 1;
    NewsManager *newsManager = [[NewsManager alloc] init];
    NSNumber *specialId = self.specialInfo[@"NodeID"];
    @weakify(self);
    [newsManager requestSpecialListByPage:self.currentPage specialId:specialId.intValue onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        NSNumber *status = responseObject[@"status"];
        if(error || status.integerValue == 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:responseObject[@"msg"]];
            }
        }
        else
        {
            self.currentPage++;
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:responseObject[@"data"][@"data"]];
            NSNumber *totalPage = responseObject[@"data"][@"totalPage"];
            self.totalPage = totalPage.integerValue;
            [self.tableView reloadData];
            self.tableView.footer.hidden = self.currentPage > self.totalPage?YES:NO;
        }
        [self.tableView.header endRefreshing];
    }];
    

}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestList];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestNextPage];
    }];
    
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) self.tableView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
}


-(void)requestNextPage
{
    NewsManager *newsManager = [[NewsManager alloc] init];
    NSNumber *specialId = self.specialInfo[@"NodeID"];
    @weakify(self);
    [newsManager requestSpecialListByPage:self.currentPage specialId:specialId.intValue onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        [self.tableView.footer endRefreshing];
        NSNumber *status = responseObject[@"status"];
        if(error || status.integerValue == 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:responseObject[@"msg"]];
            }
        }
        else
        {
            self.currentPage++;
            [self.list addObjectsFromArray:responseObject[@"data"][@"data"]];
            [self.tableView reloadData];
            self.tableView.footer.hidden = self.currentPage > self.totalPage?YES:NO;
        }
    }];
    

}


@end
