//
//  WXYSearchViewController.m
//  TXChatParent
//
//  Created by shengxin on 16/4/18.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "WXYSearchViewController.h"
//#import "MediaSearchKeyCell.h"
#import "UILabel+ContentSize.h"
#import "JCTagListView.h"
#import "WKTSearchView.h"
#import "UIColor+Hex.h"
#import "TXWebViewController.h"

@interface WXYSearchViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>{
     UIView *_contentView;//滚动条内的view;
}
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) JCTagListView *collectionView;
@property (nonatomic, strong) WKTSearchView *iWKTSearchView;
@property (nonatomic, strong) UIView *searchBackgroundView;

@end

@implementation WXYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setupTitleViews];
    [self setupSearchKeyViews];
    [self setupWKTSearchView];
    [self initSet];
//    [self addEmptyDataImage:YES showMessage:@"无搜索数据"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init
- (void)initSet{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyBoardNofication:) name:@"closeKeyBoardNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchTextChanged) name:UITextFieldTextDidChangeNotification object:_searchField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchError:) name:@"showSearchErrorMsgNotifcation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSearchNoData:) name:@"showSearchNoDataNotifcation" object:nil];
}

//初始化导航条
-(void)setupTitleViews
{
    [self createCustomNavBar];
    self.btnLeft.hidden = YES;
     UIImage *image = [UIImage imageNamed:@"media_searchicon"];
    CGFloat searchBarWidth = self.customNavigationView.frame.size.width - kEdgeInsetsLeft-50;
    self.searchBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10,self.customNavigationView.height_ - kNavigationHeight + (kNavigationHeight-26.0)/2,searchBarWidth,26.0)];
    self.searchBackgroundView.layer.cornerRadius = 4.0f/2.0f;
    self.searchBackgroundView.layer.masksToBounds = YES;
    self.searchBackgroundView.backgroundColor = RGBCOLOR(0xf0, 0xf0, 0xf0);
    [self.view addSubview:self.searchBackgroundView];
   
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7,(self.searchBackgroundView.frame.size.height-image.size.height)/2 , image.size.width, image.size.height)];
    searchIcon.image = image;
    [self.searchBackgroundView addSubview:searchIcon];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(searchIcon.frame.origin.x+searchIcon.frame.size.width+4, searchIcon.frame.origin.y,self.searchBackgroundView.frame.size.width-8-searchIcon.frame.size.width-7, 13)];
    _searchField = searchField;
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.delegate = self;
    searchField.placeholder = @"输入搜索的内容";
    searchField.font = kFontSmall;
    searchField.returnKeyType = UIReturnKeySearch;
    [searchField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.searchBackgroundView addSubview:searchField];
    [self.btnRight setTitle:@"取消" forState:UIControlStateNormal];
}

-(void)setupSearchKeyViews
{
    self.view.backgroundColor = [UIColor colorWithHexStr:@"f4f5f6"];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,(33-14)/2.0+64, 140, 14.0)];
    contentLabel.textColor = [UIColor colorWithHexStr:@"999999"];
    contentLabel.backgroundColor = [UIColor colorWithHexStr:@"f4f5f6"];;
    contentLabel.font = kFontSubTitle;
    contentLabel.text = @"大家都在搜";
    [self.view addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 64+33, self.view.frame.size.width-30,0.5)];
    lineView.backgroundColor =  [UIColor colorWithHexStr:@"e5e5e5"];
    [self.view addSubview:lineView];
    
    self.collectionView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 64+33+10, self.view.frame.size.width, self.view.frame.size.height-64-33-14)];
     self.collectionView.canSelectTags = NO;
     self.collectionView.tagCornerRadius = 5.0f;

    [self  getSearchKeyDatas];
     __weak WXYSearchViewController *weself = self;
    [self.collectionView setCompletionBlockWithSelected:^(NSInteger index) {
//        TXPBArticleSearchWord *model = [weself.collectionView.tags objectAtIndex:index];
//        weself.searchField.text = model.keyWord;
        [weself beginSearch];
        
    }];
    [self.view addSubview:self.collectionView];
    //收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDown:)];
    [tapGesture setNumberOfTapsRequired:1];
    tapGesture.delegate = self;
    tapGesture.cancelsTouchesInView = NO;
    [_collectionView addGestureRecognizer:tapGesture];
}

- (void)setupWKTSearchView{//搜索界面
    self.iWKTSearchView = [[WKTSearchView alloc] initWithFrame:CGRectMake(0,64,self.view.frame.size.width, self.view.frame.size.height-64)];
    __weak WXYSearchViewController *weself = self;
//    self.iWKTSearchView.wDelegate = ^(TXPBArticleAbstract* model){
//        TXWebViewController *detailVc = [[TXWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@&pf=WJY",model.detailUrl ]];
//        detailVc.requireShare = YES;
//        detailVc.titleStr = @"";
//        [detailVc setShareUrl:model.shareUrl];
//        [weself.navigationController pushViewController:detailVc animated:YES];
//    };
    [self.view addSubview:self.iWKTSearchView];
    self.iWKTSearchView.hidden = YES;

}

- (void)getSearchKeyDatas{
    __weak WXYSearchViewController *weself = self;
//    [[TXChatClient sharedInstance].learnGardenManager fetch_recommandedSearchWords:^(NSError *error, NSArray<TXPBArticleSearchWord *> *searchWordsArray) {
//        if (searchWordsArray.count!=0) {
//            [weself.collectionView.tags addObjectsFromArray:searchWordsArray];
//            [weself.collectionView.collectionView reloadData];
//        }
//    }];
}

#pragma mark - SearchTextChanged Notification
- (void)searchTextChanged
{
    if(_searchField.text.length == 0)
    {
        [self showSearchResultView:NO];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_searchField.text.length > 0)
    {
        [_searchField resignFirstResponder];
        [self beginSearch];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self showSearchResultView:NO];
    return YES;
}

-(void)showSearchResultView:(BOOL)isShow
{
//    [self updateEmptyDataImageStatus:NO];
    if(!isShow)
    {
        self.iWKTSearchView.hidden = YES;
    }else{
        self.iWKTSearchView.hidden = NO;
    }
}

- (void)beginSearch{
//    [self updateEmptyDataImageStatus:NO];
    self.iWKTSearchView.hidden = NO;
    [self.iWKTSearchView setSearchData:self.searchField.text];
}

#pragma mark-- 隐藏键盘
- (void)keyboardDown:(UITapGestureRecognizer *)recognizer
{
    UIView *tabView = recognizer.view;
    NSLog(@"view class:%@", [tabView class]);
    
    //去除键盘
    [_searchField resignFirstResponder];
}

#pragma mark - closeKeyBoardNofication
- (void)closeKeyBoardNofication:(id)notification{
    //去除键盘
    [_searchField resignFirstResponder];
}

- (void)showSearchError:(id)notification{
    NSDictionary *dict = [notification userInfo];
    NSError *error = [dict objectForKey:@"data"];
    if(error==nil){
        [self showFailedHudWithTitle:@"无更多数据"];
    }else{
        [self showFailedHudWithError:error];
    }
}

- (void)showSearchNoData:(id)notification{
//    [self updateEmptyDataImageStatus:YES];
}

#pragma mark - UITouch
- (void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonRight){
        [self.navigationController popViewControllerAnimated:YES];
//        [MobClick event:@"media_search_cancel_pressed"];
    }
}

- (void)showSearchFieldBtn:(id)sender{
    [_searchField becomeFirstResponder];
}

@end
