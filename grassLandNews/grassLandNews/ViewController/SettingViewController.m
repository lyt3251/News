//
//  SettingViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import "NewsFileManger.h"

#define KCellHight 45.0f
#define KCellHeaderHight 5.0f
#define KCellTagBase 0x1000

typedef enum : NSUInteger {
    SettingType_Cache = 0, //缓存
    SettingType_Font, //字体大小
    SettingType_FeedBack, //意见反馈
    SettingType_Comment, //评论
    
} SettingType;

@interface SettingViewController()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *list;
@property(nonatomic, strong)NSString *fontStr;
@end



@implementation SettingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    self.titleStr = @"设置";
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    [self initList];
    [self setupViews];
    
}

-(void)initList
{
    
    self.list = @[@[@{@"title":@"清楚缓存", @"type":@(SettingType_Cache)},
                    @{@"title":@"调整字体大小", @"type":@(SettingType_Font)}],
                  @[@{@"title":@"意见反馈", @"type":@(SettingType_FeedBack)},
                    @{@"title":@"给我们评分", @"type":@(SettingType_Comment)}]];
    
    
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

-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self presentLeftMenuViewController:sender];
    }
}


#pragma mark-- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)self.list[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.list.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *dic = ((NSArray *)self.list[indexPath.section])[indexPath.row];
    NSNumber *type = dic[@"type"];
//    if(type.integerValue == SettingType_Cache || )
    static NSString *identifier = @"UITableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = kFontNewsSubTitle;
        titleLabel.textColor = kColorNewsTitle;
        titleLabel.tag = KCellTagBase + 1;
        [cell.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(kEdgeInsetsLeft, (KCellHight - 30)/2, 100, 30);
        
        UILabel *subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.font = kFontNewsSubTitle;
        subTitleLabel.textColor = kColorNewsTitle;
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        subTitleLabel.tag = KCellTagBase + 2;
        [cell.contentView addSubview:subTitleLabel];
        subTitleLabel.frame = CGRectMake(kScreenWidth - 100 - kEdgeInsetsLeft, (KCellHight - 30)/2, 100, 30);
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kColorLine;
        lineView.tag = KCellTagBase + 3;
        [cell.contentView addSubview:lineView];
        lineView.frame = CGRectMake(kEdgeInsetsLeft, KCellHight - kLineHeight, kScreenWidth - kEdgeInsetsLeft, kLineHeight);
    }

    UILabel *titleLabel = [cell.contentView viewWithTag:KCellTagBase + 1];
    UILabel *subTitleLabel = [cell.contentView viewWithTag:KCellTagBase + 2];
    UIView *lineView = [cell.contentView viewWithTag:KCellTagBase + 3];
    titleLabel.text = dic[@"title"];
    if(type.integerValue == SettingType_Cache)
    {
        unsigned long long size = [[NewsFileManger shareInstance] getCacheFileSize];
        CGFloat sizeByM = size/(1000*1000.0f);
        subTitleLabel.text = [NSString stringWithFormat:@"%.02fMB", sizeByM];
        subTitleLabel.hidden = NO;
        lineView.hidden = NO;
    }
    else if(type.integerValue == SettingType_Font)
    {
        NSString *font = [[NSUserDefaults standardUserDefaults] valueForKey:TX_SETTING_FONT];
        
        subTitleLabel.text = font.length > 0?font:@"中";
        subTitleLabel.hidden = NO;
        lineView.hidden = YES;
    }
    else
    {
        subTitleLabel.hidden = YES;
        lineView.hidden = type.integerValue == SettingType_Comment?YES:NO;
    }

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
    NSNumber *type = self.list[indexPath.section][indexPath.row][@"type"];
    switch (type.integerValue) {
        case SettingType_FeedBack:
        {
            FeedBackViewController *feedbackVC = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
            
        }
            break;
            
        case SettingType_Font:
        {
            NSArray *list = @[@"大", @"中", @"小"];
            NSString * font = [[NSUserDefaults standardUserDefaults] valueForKey:TX_SETTING_FONT];
            NSArray *hightList = nil;
            NSUInteger index = 0;
            if(font.length <= 0)
            {
                font = @"中";
            }
            hightList = @[font];
            index = [list indexOfObject:font];
            NSArray *firstList = nil;
            if(index != 0)
            {
                firstList = [list subarrayWithRange:NSMakeRange(0, index)];
            }
            NSArray *secList = nil;
            if(index != list.count-1)
            {
                secList = [list subarrayWithRange:NSMakeRange(index+1, list.count - index -1)];
            }
            
            @weakify(self);
            [self showHighlightedSheetWithTitle:nil normalItems:firstList highlightedItems:hightList otherItems:secList clickHandler:^(NSInteger index) {
                @strongify(self);
                NSString *selectedFont = list[index];
                [[NSUserDefaults standardUserDefaults] setObject:selectedFont forKey:TX_SETTING_FONT];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.tableView reloadData];
            } completion:^{
                
            }];
        
        }
            break;
        default:
            break;
    } ;
}


@end
