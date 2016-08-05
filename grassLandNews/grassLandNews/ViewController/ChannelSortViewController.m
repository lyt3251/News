//
//  ChannelSortViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "ChannelSortViewController.h"

#define KCellHight 45.0f
#define KCellTagBase 0x1000

@interface ChannelSortViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *leftTableView;
@property(nonatomic, strong)UITableView *rightTableView;
@property(nonatomic, strong)NSMutableArray *leftTitles;
@property(nonatomic, strong)NSMutableArray *rightTitles;
@property(nonatomic, strong)UIImageView *screenshot;
@end

@implementation ChannelSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    self.titleStr = @"测试测试";
//    [self.btnRight setTitle:@"测试截屏" forState:UIControlStateNormal];
    [self initTitles];
    [self setupViews];
    
}

-(void)initTitles
{
    self.leftTitles = [NSMutableArray array];
    for(NSInteger i = 0; i < 10; i++)
    {
        [self.leftTitles addObject:[NSString stringWithFormat:@"测试%@", @(i)]];
    }
    
    self.rightTitles = [NSMutableArray array];
    for(NSInteger i = 0; i < 5; i++)
    {
        [self.rightTitles addObject:[NSString stringWithFormat:@"测试%@", @(i)]];
    }
    
}


-(void)setupViews
{
    self.leftTableView = [[UITableView alloc] init];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.rowHeight = KCellHight;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.customNavigationView.maxY);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    
    self.rightTableView = [[UITableView alloc] init];
    self.rightTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.rowHeight = KCellHight;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kScreenWidth/2);
        make.top.mas_equalTo(self.customNavigationView.maxY);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
}


-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonRight)
    {
//        [self captureScreenshot];
    }

}


-(void)captureScreenshot
{

    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _screenshot.image = image;
    NSString *homePath = NSHomeDirectory();
    [UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"%@/Documents/a.png", homePath] atomically:YES];
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
#pragma mar-- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.leftTableView)
    {
        return self.leftTitles.count;
    }
    else if(tableView == self.rightTableView)
    {
        return self.rightTitles.count;
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = KCellTagBase + 1;
        titleLabel.frame = CGRectMake(15, 7.5, kScreenWidth-15-20-15, 30);
        [cell.contentView addSubview:titleLabel];
    
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"Main_RightArrow"];
        rightImageView.tag = KCellTagBase + 2;
        rightImageView.frame = CGRectMake(kScreenWidth/2 - 15- rightImageView.image.size.width, (KCellHight - rightImageView.image.size.height)/2, rightImageView.image.size.width, rightImageView.image.size.height);
        [cell.contentView addSubview:rightImageView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBCOLOR(0xea, 0xea, 0xea);
        lineView.frame = CGRectMake(0, KCellHight - 0.5f, kScreenWidth/2, 0.5f);
        [cell.contentView addSubview:lineView];
    }
    
    UILabel *titleLabel = [cell.contentView viewWithTag:KCellTagBase + 1];
    UIImageView *rightImageView = [cell.contentView viewWithTag:KCellTagBase + 2];
    rightImageView.hidden = tableView == self.rightTableView?YES:NO;

    if(tableView == self.rightTableView)
    {
        titleLabel.text = self.rightTitles[indexPath.row];
    }
    else if(tableView == self.leftTableView)
    {
        titleLabel.text = self.leftTitles[indexPath.row];
    }

    return cell;
}

#pragma mar-- UITableViewDelegate
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.leftTableView)
    {
        self.rightTitles = [NSMutableArray array];
        for(NSInteger i = 0; i < indexPath.row + 1; i++)
        {
            [self.rightTitles addObject:[NSString stringWithFormat:@"测试刷新%@", @(i)]];
        }
        [self.rightTableView reloadData];
    }
    else
    {
    
    }
}



@end
