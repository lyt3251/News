//
//  PushMsgViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "PushMsgViewController.h"
#import "NewsManager.h"

#define KCellHight 72.0f
#define KCellHeaderHight 5.0f
#define KCellTagBase 0x1000

@interface PushMsgViewController()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *list;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, assign)NSInteger totalPage;

@end

@implementation PushMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    // Do any additional setup after loading the view.
    self.customNavigationView.backgroundColor = KColorAppMain;
    self.titleStr = @"消息推送";
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = KCellHight;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(self.customNavigationView.maxY, 0, 0, 0));
    }];
    self.tableView.backgroundColor = kColorBackground;
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
    static NSString *identifier = @"UITableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *fromUserLabel = [[UILabel alloc] init];
        fromUserLabel.font = kFontChildSection;
        fromUserLabel.textColor = KColorAppMain;
        fromUserLabel.tag = KCellTagBase + 1;
        [cell.contentView addSubview:fromUserLabel];
//        fromUserLabel.frame = CGRectMake(kEdgeInsetsLeft, kEdgeInsetsLeft, 150, 20);
        [fromUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kEdgeInsetsLeft);
            make.top.mas_equalTo(kEdgeInsetsLeft);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = kFontChildSection;
        timeLabel.textColor = kColorNewsChannel;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.tag = KCellTagBase + 2;
        [cell.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fromUserLabel.mas_right);
            make.top.mas_equalTo(fromUserLabel);
            make.right.mas_equalTo(-kEdgeInsetsLeft);
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontSubTitle;
        titleLabel.textColor = kColorNewsTitle;
        titleLabel.tag = KCellTagBase + 3;
        [cell.contentView addSubview:titleLabel];
//        titleLabel.frame = CGRectMake(kEdgeInsetsLeft, KCellHight - 24- 15, kScreenWidth - 2*kEdgeInsetsLeft, 24);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fromUserLabel);
            make.bottom.mas_equalTo(-kEdgeInsetsLeft);
            make.right.mas_equalTo(-kEdgeInsetsLeft);
        }];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColorLine;
        lineView.tag = KCellTagBase + 4;
        [cell.contentView addSubview:lineView];
        lineView.frame = CGRectMake(kEdgeInsetsLeft, KCellHight - kLineHeight, kScreenWidth - kEdgeInsetsLeft, kLineHeight);
    }
    
    UILabel *fromUserLabel = [cell.contentView viewWithTag:KCellTagBase + 1];
    UILabel *timeLabel = [cell.contentView viewWithTag:KCellTagBase + 2];
    UILabel *titleLabel = [cell.contentView viewWithTag:KCellTagBase + 3];
    
    NSDictionary *systemMsg = self.list[indexPath.row];
    
    fromUserLabel.text = @"系统管理员";
    timeLabel.text = systemMsg[@"pushTime"];
    titleLabel.text = systemMsg[@"title"];
    
    
    return cell;
}

#pragma mark-- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KCellHeaderHight;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    
    if(section == 1)
    {
        UIView *beginLineView = [[UIView alloc] init];
        beginLineView.backgroundColor = kColorLine;
        [header addSubview:beginLineView];
        beginLineView.frame = CGRectMake(0, 0, kScreenWidth, kLineHeight);
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColorLine;
    [header addSubview:lineView];
    lineView.frame = CGRectMake(0, KCellHeaderHight-kLineHeight, kScreenWidth, kLineHeight);
    return header;
}

#pragma mark-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)requestList
{
    self.currentPage = 1;
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [newsManager requestPushMsgsByPage:self.currentPage onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
            //                self.totalPage = responseObject[@""];
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
        [self.tableView.header endRefreshing];
    }];
    
}

-(void)requestNextPage
{
    
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [newsManager requestPushMsgsByPage:self.currentPage onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
            //                self.totalPage = responseObject[@""];
            [self.list removeAllObjects];
            [self.list addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
        [self.tableView.footer endRefreshing];
    }];

}



@end
