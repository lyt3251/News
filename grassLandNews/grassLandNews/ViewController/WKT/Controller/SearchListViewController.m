//
//  SearchListViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/8.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "SearchListViewController.h"
#import "NewsOnlyTextTableViewCell.h"

@interface SearchListViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITextField *inputText;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    [self setupViews];
    
}

-(void)createCustomNavBar
{
    [super createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    [self.btnRight setTitle:@"取消" forState:UIControlStateNormal];
    [self.btnRight setTitleColor:kColorWhite forState:UIControlStateNormal];
    
    self.inputText = [[UITextField alloc] init];
    self.inputText.delegate = self;
    self.inputText.backgroundColor = RGBCOLOR(49, 120, 75);
    self.inputText.textColor = kColorWhite;
    self.inputText.returnKeyType = UIReturnKeySearch;
    [self.inputText setTintColor:kColorBlue];
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
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NewsOnlyTextTableViewCell";
    
    NewsOnlyTextTableViewCell *newsOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!newsOnlyTextCell)
    {
        newsOnlyTextCell = [[NewsOnlyTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //        newsOnlyTextCell.titleLabel.text = @"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题";
    [newsOnlyTextCell.titleLabel setTextByStr:@"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题标题测试标题测试标题标题测试标题测试标题标题测试标题测试标题" WithSpace:7.0f];
    newsOnlyTextCell.subTitleLabel.text = @"标签标签标签标签";
    
    return newsOnlyTextCell;
}
#pragma mark-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputText resignFirstResponder];
    return YES;
    
}

@end
