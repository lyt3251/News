//
//  WKTSearchView.m
//  TXChatParent
//
//  Created by shengxin on 16/4/19.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WKTSearchView.h"
#import "WKTSearchTableViewCell.h"
#import "MJRefresh.h"
#import "UIColor+Hex.h"
#import "WXYNewListTableViewCell.h"

#define WKTSearchTableViewIdentifer @"WKTSearchTableViewIdentifer"
#define WKTSearchTableViewCellNibName @"WKTSearchTableViewCell"

@interface WKTSearchView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger currentPage;
    BOOL canGetSearchData;
    NSInteger sumNum;
}

@property (nonatomic, strong) NSMutableArray *iTableViewArr;
@property (nonatomic, strong) NSString *iSearchText;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation WKTSearchView

#pragma mark - public
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableView];
        [self setupRefresh];
        
    }
    return self;
}

- (void)setSearchData:(NSString*)aSearchText{
    self.iSearchText = aSearchText;
    currentPage = 1;
    [self.iTableViewArr removeAllObjects];
    self.iTableView.footer.hidden = NO;
    [self getSearchData:currentPage];
    
    [self.iTableView reloadData];
}

#pragma mark - private
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iTableView.frame = self.bounds;
}

- (void)getSearchData:(NSInteger)aCurrentPage{
    if (canGetSearchData==NO) {
        return;
    }
    NSLog(@"S");
    __weak WKTSearchView *weself = self;
//    [[TXChatClient sharedInstance].learnGardenManager fetch_searchArticlesByKeyWrod:self.iSearchText withPage:(int32_t)aCurrentPage completed:^(NSError *error, NSArray<TXPBArticleAbstract *> *articlesArray, bool hasMore, int64_t total){
//        canGetSearchData = YES;
//        [weself.iTableView.footer endRefreshing];
//        if(error){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchErrorMsgNotifcation" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"data", nil]];
//            return;
//        }
//        sumNum = total;
//        [weself.iTableView reloadData];
//        //搜索无结果
//        if (articlesArray.count==0) {
//            if(aCurrentPage==1){
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchNoDataNotifcation" object:nil];
//            }else{
//                NSError *error = nil;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"showSearchErrorMsgNotifcation" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"data", nil]];
//                weself.iTableView.footer.hidden = YES;
//            }
//            
//            return ;
//        }
//        currentPage++;
//        [weself.iTableViewArr addObjectsFromArray:articlesArray];
//        [weself.iTableView reloadData];
//        //无更多数据
//        if (hasMore!=true) {
//            weself.iTableView.footer.hidden = YES;
//        }
//        
//        
//    }];
}

#pragma mark - init
- (void)initTableView{
    
    self.iTableViewArr = [NSMutableArray array];
    self.iTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.iTableView.delegate = self;
    self.iTableView.dataSource = self;
    self.iTableView.separatorColor = [UIColor clearColor];
    [self addSubview:self.iTableView];

    [self.iTableView registerNib:[UINib nibWithNibName:@"WXYNewListTableViewCell"  bundle:nil] forCellReuseIdentifier:@"WXYNewListTableViewCellIndetifer"];
//    [self.iTableView registerNib:[UINib nibWithNibName:WKTSearchTableViewCellNibName  bundle:nil] forCellReuseIdentifier:WKTSearchTableViewIdentifer];
}

//集成刷新控件
- (void)setupRefresh
{
    currentPage = 1;
    canGetSearchData = YES;
    
    __weak typeof(self)tmpObject = self;
    self.iTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [tmpObject footerRereshing];
    }];
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) self.iTableView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
}

/**
 *  上拉刷新
 */
- (void)footerRereshing{
   [self getSearchData:currentPage];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.iTableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"section1"];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section1"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,33.0)];
            view.backgroundColor = self.backgroundColor;
            self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,(33-14)/2.0, 140, 14.0)];
            self.contentLabel.textColor = [UIColor colorWithHexStr:@"999999"];
            self.contentLabel.backgroundColor = [UIColor clearColor];;
            self.contentLabel.font = kFontSubTitle;
            UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(15,32,self.frame.size.width-30,1)];
            viewLine.backgroundColor = [UIColor colorWithHexStr:@"eeeeee"];
            [view addSubview:self.contentLabel];
            [view addSubview:viewLine];
            [cell.contentView addSubview:view];
        }
        self.contentLabel.text = [NSString stringWithFormat:@"相关文章(%li)",(long)sumNum];
        return cell;
    }
    WXYNewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXYNewListTableViewCellIndetifer"];
//    TXPBArticleAbstract *model = [self.iTableViewArr objectAtIndex:indexPath.row];
//    [cell setSearchData:model andSearchText:self.iSearchText];
    return cell;
//    WKTSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WKTSearchTableViewIdentifer forIndexPath:indexPath];
//    
//    TXPBArticleAbstract *model = [self.iTableViewArr objectAtIndex:indexPath.row];
//    [cell setData:model andSearchText:self.iSearchText];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TXPBArticleAbstract *model = [self.iTableViewArr objectAtIndex:indexPath.row];
//    self.wDelegate(model);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 33.0;
    }else{
        return 80+15+15+1;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeKeyBoardNotification" object:nil];
}

@end
