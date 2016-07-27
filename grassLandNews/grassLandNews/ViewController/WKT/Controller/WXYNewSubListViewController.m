//
//  WXYNewSubListViewController.m
//  TXChatParent
//
//  Created by shengxin on 16/4/15.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WXYNewSubListViewController.h"
#import "WXYNewListTableViewCell.h"
//#import "MJTXRefreshGifHeader.h"
#import "MJRefreshAutoStateFooter.h"
#import "MJRefreshAutoNormalFooter.h"

#define WXYNewListTableViewCellIndetifer @"WXYNewListTableViewCellIndetifer"
#define WXYTableViewNibName @"WXYNewListTableViewCell"

@interface WXYNewSubListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
    BOOL isGetListData;
}
@property (nonatomic, strong) UITableView *iWXYNewListTableView;
@property (nonatomic, strong) NSMutableArray *iTableViewArr;
@property (nonatomic, assign) NSInteger iChannelId;

@end

@implementation WXYNewSubListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableViewArr];
    [self initTableView];
    [self setupRefresh];
    [self.iWXYNewListTableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //已读内容列表颜色及时更新
    [self.iWXYNewListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public
- (void)loadData:(NSInteger)aChannelId{
    isGetListData = YES;
    self.iChannelId = aChannelId;
}

- (void)getListData:(NSInteger)aCurrentPage{
    if (isGetListData==NO) {
        return;
    }
    __weak WXYNewSubListViewController *weself = self;
//    [[TXChatClient sharedInstance].learnGardenManager fetch_articleListByType:self.iChannelId withPage:(int )aCurrentPage completed:^(NSError *error, NSArray<TXPBArticleAbstract *> *articlesArray, bool hasMore) {
//        isGetListData = YES;
//        if(error){
//            [self showFailedHudWithError:error];
//            [weself.iWXYNewListTableView.header endRefreshing];
//            [weself.iWXYNewListTableView.footer endRefreshing];
//            return;
//        }
//        if (aCurrentPage!=1&&articlesArray.count==0) {
////            [self showSuccessHudWithTitle:@"无数据"];
//            [weself.iWXYNewListTableView.header endRefreshing];
//            [weself.iWXYNewListTableView.footer endRefreshing];
//            [weself.iWXYNewListTableView.footer setHidden:YES];
//            return;
//        }else if (articlesArray.count==0) {
////            [self showSuccessHudWithTitle:@"无数据"];
//            [weself.iWXYNewListTableView.header endRefreshing];
//            [weself.iWXYNewListTableView.footer endRefreshing];
//            return;
//        }
//        
//        currentPage = aCurrentPage;
//        if (aCurrentPage==1) {
//            [weself.iTableViewArr removeAllObjects];
//        }
//        [weself.iTableViewArr addObjectsFromArray:articlesArray];
//        [weself.iWXYNewListTableView.footer endRefreshing];
//        [weself.iWXYNewListTableView.header endRefreshing];
//        [weself.iWXYNewListTableView reloadData];
//       
//        if (hasMore!=true) {
//            [weself.iWXYNewListTableView.footer setHidden:YES];
//        }else{
//            [weself.iWXYNewListTableView.footer setHidden:NO];
//        }
//       
//    }];
}

#pragma mark - init
- (void)initTableView{
  
    self.iWXYNewListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64-43) style:UITableViewStylePlain];
    self.iWXYNewListTableView.delegate = self;
    self.iWXYNewListTableView.dataSource = self;
    self.iWXYNewListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.iWXYNewListTableView.rowHeight = 80+15+15+1;
    [self.view addSubview:self.iWXYNewListTableView];
    
    [self.iWXYNewListTableView registerNib:[UINib nibWithNibName:WXYTableViewNibName  bundle:nil] forCellReuseIdentifier:WXYNewListTableViewCellIndetifer];
}

- (void)initTableViewArr{
    self.iTableViewArr = [NSMutableArray array];
    currentPage = 1;
    isGetListData = YES;
}

//集成刷新控件
- (void)setupRefresh
{
    __weak typeof(self)tmpObject = self;
    _iWXYNewListTableView.header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [tmpObject headerRereshing];
    }];
    _iWXYNewListTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [tmpObject footerRereshing];
    }];
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) _iWXYNewListTableView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
}

#pragma mark - 下拉刷新 拉取本地历史消息
- (void)headerRereshing{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf getListData:1];
    });
}

- (void)footerRereshing{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf getListData:currentPage+1];
    });
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.iTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WXYNewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WXYNewListTableViewCellIndetifer];
//    TXPBArticleAbstract *model = [self.iTableViewArr objectAtIndex:indexPath.row];
//    [cell setData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TXPBArticleAbstract *model = [self.iTableViewArr objectAtIndex:indexPath.row];
//    self.tBlock(model);
}


@end
