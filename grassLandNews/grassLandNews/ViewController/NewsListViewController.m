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

@interface NewsListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = RGBCOLOR(0x44, 0x99, 0x69);
    self.titleLb.textColor = [UIColor whiteColor];
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    self.titleStr = self.ListTitle;
    // Do any additional setup after loading the view.
    [self setupViews];
    
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
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
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(indexPath.row%2 == 0)
    {
        static NSString *identifier = @"NewsWithPhotoTableViewCell";
        NewsWithPhotoTableViewCell *newsWithPhotoCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!newsWithPhotoCell)
        {
            newsWithPhotoCell = [[NewsWithPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [newsWithPhotoCell.titleLabel setTextByStr:@"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题" WithSpace:7.0f];
        newsWithPhotoCell.subTitleLabel.text = @"标签标签标签标签";
        
        [newsWithPhotoCell.rightImageView sd_setImageWithURL:[NSURL URLWithString:@"http://n.sinaimg.cn/news/20160803/6f47-fxupmws1661759.jpg"] placeholderImage:[UIImage imageNamed:@"Left_Header"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
        [newsOnlyTextCell.titleLabel setTextByStr:@"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题" WithSpace:7.0f];
        newsOnlyTextCell.subTitleLabel.text = @"标签标签标签标签";
        
        cell = newsOnlyTextCell;
    }
    
    return cell;
}

#pragma mark-- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
