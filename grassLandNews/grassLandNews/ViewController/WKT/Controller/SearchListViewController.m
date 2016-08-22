//
//  SearchListViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/8.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "SearchListViewController.h"
#import "NewsOnlyTextTableViewCell.h"
#import "SearchTxtTableViewCell.h"
#import "NewsManager.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"
#import "NewsWithPhotoTableViewCell.h"

@interface SearchListViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITextField *inputText;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)BOOL isSearching;
@property(nonatomic, strong)NSMutableArray *newsList;
@property(nonatomic, strong)NSMutableArray *recommandList;
@property(nonatomic, assign)NSInteger currentPage;
@property(nonatomic, assign)NSInteger totalPage;
@property(nonatomic, assign)NSInteger recommandCurrentPage;
@property(nonatomic, assign)NSInteger recommandTotalPage;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSearching = NO;
    [self createCustomNavBar];
    self.newsList = [NSMutableArray arrayWithCapacity:1];
    self.recommandList = [NSMutableArray arrayWithCapacity:1];
    [self setupViews];
    [self searchRecommandList];
    [self setupRefresh];
}

-(void)createCustomNavBar
{
    [super createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    [self.btnRight setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnRight setTitleColor:kColorWhite forState:UIControlStateNormal];
    
    self.inputText = [[UITextField alloc] init];
    self.inputText.font = kFontNewsSubTitle;
    self.inputText.delegate = self;
    self.inputText.backgroundColor = RGBACOLOR(0, 0, 0, 0.1f);
    self.inputText.textColor = kColorWhite;
    self.inputText.returnKeyType = UIReturnKeySearch;
    self.inputText.placeholder = @"请输入您想要搜索的内容";
    [self.inputText setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2f] forKeyPath:@"_placeholderLabel.textColor"];
    [self.inputText setTintColor:kColorBlue];
    self.inputText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.inputText.leftViewMode = UITextFieldViewModeAlways;
    self.inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.customNavigationView addSubview:self.inputText];
    [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kEdgeInsetsLeft);
        make.centerY.mas_equalTo(self.btnRight);
        make.right.mas_equalTo(-55);
        make.height.mas_equalTo(30);
    }];
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
    if(sender.tag == TopBarButtonRight)
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
    if(self.isSearching)
    {
        return self.newsList.count;
    }
    
    return self.recommandList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(self.isSearching)
    {
        NSDictionary *newsDic = self.newsList[indexPath.row];
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
            
            cell = newsOnlyTextCell;
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            static NSString *identifier = @"UITableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
                UIView *bkView = [[UIView alloc] init];
                [cell.contentView addSubview:bkView];
                
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageNamed:@"Main_SearchGreen"];
                [bkView addSubview:imageView];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(0);
                    make.centerY.mas_equalTo(0);
                    make.size.mas_equalTo(imageView.image.size);
                }];
                
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.textColor = KColorAppMain;
                titleLabel.font = kFontNewsSubTitle;
                titleLabel.text = @"大家都在搜";
                [bkView addSubview:titleLabel];
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).with.offset(10);
                    make.centerY.mas_equalTo(0);
                }];
                
                [bkView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.centerX.mas_equalTo(0);
                    make.right.mas_equalTo(titleLabel.mas_right);
                    make.height.mas_equalTo(@[imageView, titleLabel]);
                }];
                
                
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = kColorLine;
                [cell.contentView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kEdgeInsetsLeft);
                    make.right.mas_equalTo(-kEdgeInsetsLeft);
                    make.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(kLineHeight);
                }];
            }
        
        }
        else
        {
            static NSString *identifier = @"SearchTxtTableViewCell";
            SearchTxtTableViewCell *searchTxtCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!searchTxtCell)
            {
                searchTxtCell = [[SearchTxtTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            searchTxtCell.titleLabel.text = self.recommandList[indexPath.row];
            cell = searchTxtCell;
        }
    }
    
    return cell;
}
#pragma mark-- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isSearching)
    {
        return 100.0f;
    }
    else
    {
        if(indexPath.row == 0)
        {
            return 55.0f;
        }
        return 45.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.isSearching)
    {
        NSDictionary *newsInfo = self.newsList[indexPath.row];
        NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] initWithNewsId:newsInfo];
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
    else
    {
        self.inputText.text = self.recommandList[indexPath.row];
        self.isSearching = YES;
        [self searchNewsByKeyword];
    }
    
}


#pragma mark-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.isSearching = YES;
    [self searchNewsByKeyword];
    
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.isSearching = NO;
    [self.tableView reloadData];
    
    return YES;
}


-(void)searchRecommandList
{
//    NSString *searchKey = self.inputText.text;
//    if(searchKey.length <= 0)
//    {
//        [self showFailedHudWithTitle:@"请输入搜索关键字"];
//        return;
//    }
    self.recommandCurrentPage = 1;

    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [TXProgressHUD showHUDAddedTo:self.view animated:YES];
    [newsManager requestNewsListBySearchWords:nil page:self.recommandCurrentPage onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        [TXProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(error || status.integerValue <= 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:dic[@"msg"]];
            }
            
        }
        else
        {
            [self updateByDicList:dic[@"data"]];
            self.recommandCurrentPage ++;
            [self.tableView reloadData];
        }
    }];
    
}

-(void)updateByDicList:(NSArray *)array
{
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:1];
    for(NSDictionary *newsDic in array)
    {
        [mutableArray addObject:newsDic[@"Text"]];
    }
    
    [self.recommandList removeAllObjects];
    [self.recommandList addObjectsFromArray:mutableArray];
}


-(void)searchNewsByKeyword
{
        NSString *searchKey = self.inputText.text;
        if(searchKey.length <= 0)
        {
            [self showFailedHudWithTitle:@"请输入搜索关键字"];
            return;
        }
    self.currentPage = 1;
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [TXProgressHUD showHUDAddedTo:self.view animated:YES];
    [newsManager requestNewsListByPage:self.currentPage nodeId:0 keyword:searchKey ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        [TXProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.header endRefreshing];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(error || status.integerValue <= 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:dic[@"msg"]];
            }
            
        }
        else
        {
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:dic[@"data"]];
            self.currentPage ++;
            [self.inputText resignFirstResponder];
            [self.tableView reloadData];
        }
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
        if(self.isSearching)
        {
            [self searchNewsByKeyword];
        }
        else
        {
            [self searchRecommandList];
        }
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(self.isSearching)
        {
            [self searchNextNewsByKeyword];
        }
        else
        {
            [self searchNextRecommandList];
        }
    }];
    
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) self.tableView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
}


-(void)searchNextRecommandList
{

    
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [TXProgressHUD showHUDAddedTo:self.view animated:YES];
    [newsManager requestNewsListBySearchWords:nil page:self.recommandCurrentPage onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        [TXProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(error || status.integerValue <= 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:dic[@"msg"]];
            }
            
        }
        else
        {
            [self updateByNextDicList:dic[@"data"]];
            self.recommandCurrentPage++;
            [self.tableView reloadData];
        }
    }];
    
}

-(void)updateByNextDicList:(NSArray *)array
{
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:1];
    for(NSDictionary *newsDic in array)
    {
        [mutableArray addObject:newsDic[@"Text"]];
    }
    
    [self.recommandList addObjectsFromArray:mutableArray];
}


-(void)searchNextNewsByKeyword
{
    NSString *searchKey = self.inputText.text;
    if(searchKey.length <= 0)
    {
        [self showFailedHudWithTitle:@"请输入搜索关键字"];
        return;
    }
    NewsManager *newsManager = [[NewsManager alloc] init];
    @weakify(self);
    [TXProgressHUD showHUDAddedTo:self.view animated:YES];
    [newsManager requestNewsListByPage:self.currentPage nodeId:0 keyword:searchKey ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        [TXProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.footer endRefreshing];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSNumber *status = dic[@"status"];
        if(error || status.integerValue <= 0)
        {
            if(error)
            {
                [self showFailedHudWithError:error];
            }
            else
            {
                [self showFailedHudWithTitle:dic[@"msg"]];
            }
            
        }
        else
        {
            [self.newsList addObjectsFromArray:dic[@"data"]];
            self.currentPage++;
            [self.inputText resignFirstResponder];
            [self.tableView reloadData];
        }
    }];
    
}





@end
