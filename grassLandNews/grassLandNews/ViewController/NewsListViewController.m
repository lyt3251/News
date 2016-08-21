//
//  NewsListViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/3.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsWithPhotoTableViewCell.h"
#import "NewsOnlyTextTableViewCell.h"
#import "NewsManager.h"
#import "ChannelManager.h"

@interface NewsListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *list;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = RGBCOLOR(0x44, 0x99, 0x69);
    self.titleLb.textColor = [UIColor whiteColor];
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    if(self.ListTitle.length > 0)
    {
        self.titleStr = self.ListTitle;
    }
    else
    {
        self.titleStr = self.channelDic[@"NodeName"];
    }
    // Do any additional setup after loading the view.
    self.list = [NSMutableArray arrayWithCapacity:1];
    [self setupViews];
    [self requestList];
    
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
        if(self.listType == NewsListType_Favorites)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
    
    return cell;
}

#pragma mark-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)requestList
{
    if(self.listType == NewsListType_Favorites)
    {
    
    }
    else if(self.listType == NewsListType_SubChannel)
    {
        NewsManager *newsManager = [[NewsManager alloc] init];
        NSNumber *noteId = self.channelDic[@"NodeID"];
        @weakify(self);
        [newsManager requestNewsListByPage:1 nodeId:noteId.intValue keyword:nil ids:nil clickdesc:1 onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
                [self.list addObjectsFromArray:responseObject[@"data"]];
                [self.tableView reloadData];
            }
        }];
        
    }
}



@end
