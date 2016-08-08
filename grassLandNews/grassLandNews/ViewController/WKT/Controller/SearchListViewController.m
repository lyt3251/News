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

@interface SearchListViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITextField *inputText;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign)BOOL isSearching;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSearching = NO;
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
    UITableViewCell *cell = nil;
    
    if(self.isSearching)
    {
        static NSString *identifier = @"NewsOnlyTextTableViewCell";
        NewsOnlyTextTableViewCell *newsOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!newsOnlyTextCell)
        {
            newsOnlyTextCell = [[NewsOnlyTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [newsOnlyTextCell.titleLabel setTextByStr:@"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题标题测试标题测试标题标题测试标题测试标题标题测试标题测试标题" WithSpace:7.0f];
        newsOnlyTextCell.subTitleLabel.text = @"标签标签标签标签";
        cell = newsOnlyTextCell;
    }
    else
    {
        if(indexPath.row == 0)
        {
            static NSString *identifier = @"UITableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            const NSInteger cellTagBase = 0x1000;
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
            searchTxtCell.titleLabel.text = @"测试测试测试测试测试测试";
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
}


#pragma mark-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputText resignFirstResponder];
    self.isSearching = YES;
    [self.tableView reloadData];
    return YES;
    
}

@end
