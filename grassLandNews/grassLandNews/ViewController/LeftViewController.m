//
//  LeftViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/7/27.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+AlertView.h"

typedef enum : NSUInteger {
    LeftVCListType_MyFavorites = 0, //收藏
    LeftVCListType_Setting, //设置
    LeftVCListType_About, //关于
    LeftVCListType_Share, //分享
    
} LeftVCListType;

#define KCellHight 60.0f
#define KCellTagBase 0x1000
@interface LeftViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UIImageView *headerBtn;
@property(nonatomic, strong)UILabel *appNameLabel;
@property(nonatomic, strong)NSArray *leftList;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createCustomNavBar];
//    self.titleStr = @"左边";
    // Do any additional setup after loading the view.

    [self initListDatas];
    
    [self setupViews];
    
    
}

-(void)initListDatas
{
    
    self.leftList = @[@{@"icon":@"Left_Favorites", @"name":@"测试", @"type":@(LeftVCListType_MyFavorites)},
//                      @{@"icon":@"Left_Setting", @"name":@"设置", @"type":@(LeftVCListType_Setting)},
//                      @{@"icon":@"Left_About", @"name":@"关于我们", @"type":@(LeftVCListType_About)},
//                      @{@"icon":@"Left_Share", @"name":@"推荐给朋友", @"type":@(LeftVCListType_Share)}
                      ];
    
}


-(void)setupViews
{
    self.view.backgroundColor = RGBACOLOR(0x44, 0x99, 0x69, 0.85);
    
    
//    self.headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.headerBtn setImage:[UIImage imageNamed:@"Left_Header"] forState:UIControlStateNormal];
    self.headerBtn = [[UIImageView alloc] init];
    [self.headerBtn setImage:[UIImage imageNamed:@"Left_Header"]];
    [self.view addSubview:self.headerBtn];
    [self.headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(125);
        make.size.mas_equalTo(CGSizeMake(35*2, 35*2));
    }];

    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.text = @"title";
    self.appNameLabel.font = [UIFont systemFontOfSize:20];
    self.appNameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.appNameLabel];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerBtn.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.headerBtn);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.rowHeight = KCellHight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerBtn.mas_bottom).with.offset(80);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(self.leftList.count*KCellHight);
    }];
    
    
    
    
    

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
    return self.leftList.count;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.frame = CGRectMake(30, 0, 30, 30);
        icon.tag = KCellTagBase + 1;
        [cell.contentView addSubview:icon];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.tag = KCellTagBase + 2;
        label.frame = CGRectMake(75, 0, 100, 30);
        [cell.contentView addSubview:label];
    }

    UIImageView *icon = [cell viewWithTag:KCellTagBase +1];
    UILabel *label = [cell viewWithTag:KCellTagBase + 2];
    NSDictionary *dic = self.leftList[indexPath.row];
    [icon setImage:[UIImage imageNamed:dic[@"icon"]]];
    label.text = dic[@"name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ButtonItem *confirmBtn = [ButtonItem itemWithLabel:@"确定" andTextColor:[UIColor redColor] action:^{
        
    }];
    
    [self showAlertViewWithMessage:@"1111111" andButtonItems:confirmBtn, nil];
}


@end
