//
//  NewsDetailViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsFileManger.h"
#import "FavoritesManager.h"


#define KBottomBarHight  55.0f
#define KButtonTagBase 0x1000

@interface NewsDetailViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
//@property(nonatomic, strong)NSString *urlStr;
@property(nonatomic, strong)NSDictionary *newsDicInfo;
@end

@implementation NewsDetailViewController


-(id)initWithNewsId:(NSDictionary *)newsDic
{
    self = [super init];
    if(self)
    {
        _newsDicInfo = newsDic;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
//    _titleLb.frame = CGRectMake(0, 0,_shouldLimitTitleLabelWidth ? _customNavigationView.width_ - _btnLeft.width_ - _btnRight.width_ : _customNavigationView.width_, kNavigationHeight);
//    _titleLb.center = CGPointMake(_customNavigationView.center.x, _customNavigationView.height_ - kNavigationHeight / 2);
    self.titleLb.frame = CGRectMake(50, self.btnLeft.minY, kScreenWidth - (50*2), kNavigationHeight);
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    
    [self setupViews];
    [self requestFileData];
}

-(void)setupViews
{
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(self.customNavigationView.maxY, 0, -KBottomBarHight, 0));
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.customNavigationView.maxY);
        make.bottom.mas_equalTo(-KBottomBarHight);
    }];
    
    
    UIView *bottomBackGroundView = [[UIView alloc] init];
    bottomBackGroundView.backgroundColor = RGBCOLOR(0xf5, 0xf5, 0xf5);
    [self.view addSubview:bottomBackGroundView];
    [bottomBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.mas_equalTo(0);
        make.height.mas_equalTo(KBottomBarHight);
    }];
    
    UIView *beginLine = [[UIView alloc] init];
    beginLine.backgroundColor = kColorLine;
    [bottomBackGroundView addSubview:beginLine];
    [beginLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    CGFloat leftMargin = 40.0f;
    CGFloat itemWidth = 40.0f;
    CGFloat margin = (kScreenWidth - leftMargin*2 - itemWidth*3)/2;
    
    for(NSInteger i = 0; i < 3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = KButtonTagBase + i;
        [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBackGroundView addSubview:button];
        button.frame = CGRectMake(leftMargin + i*itemWidth + margin*i, (KBottomBarHight - itemWidth)/2, itemWidth, itemWidth);
        NSString *iconName = @"";
        if(i == 0)
        {
            iconName = @"Detail_Font";
        }
        else if(i == 1)
        {
            NSNumber *newsId = self.newsDicInfo[@"GeneralID"];
            BOOL isFavorites = [[FavoritesManager shareInstance] isFavoritesByNewsId:newsId.longLongValue];
            if(isFavorites)
            {
                iconName = @"Detail_Favorites";
            }
            else
            {
                iconName = @"Detail_UnFavorites";
            }
        }
        else if (i == 2)
        {
            iconName = @"Detail_Share";
        }
        
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    
    }
    
}

-(void)requestFileData
{
    NSNumber *newsId = self.newsDicInfo[@"GeneralID"];
    @weakify(self);
    [[NewsFileManger shareInstance] requestFileById:newsId.longLongValue onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        @strongify(self);
        if(responseObject)
        {
            [self.webView loadData:(NSData *)responseObject MIMEType:@"text/html" textEncodingName:@"utf-8"  baseURL:[NSURL URLWithString:@""]];
        }
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


-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        if([self.webView canGoBack])
        {
            [self.webView goBack];
        }
        else
        {
            if(self.navigationController)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}


-(void)bottomBtnClick:(UIButton *)button
{
    if(button.tag == KButtonTagBase)
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
        
        [self showHighlightedSheetWithTitle:nil normalItems:firstList highlightedItems:hightList otherItems:secList clickHandler:^(NSInteger index) {
            NSString *selectedFont = list[index];
            [[NSUserDefaults standardUserDefaults] setObject:selectedFont forKey:TX_SETTING_FONT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self changeFont];
        } completion:^{
            
        }];
        
        
    }
    else if(button.tag == KButtonTagBase + 1)
    {
        NSNumber *newsId = self.newsDicInfo[@"GeneralID"];
        BOOL isFavorites = [[FavoritesManager shareInstance] isFavoritesByNewsId:newsId.longLongValue];
        if(isFavorites)
        {
            [[FavoritesManager shareInstance] removeFavoritesByNewsId:newsId.longLongValue];
        }
        else
        {
            [[FavoritesManager shareInstance] addNewsFavorites:self.newsDicInfo];
        }
        isFavorites = !isFavorites;
        if(isFavorites)
        {
            [button setImage:[UIImage imageNamed:@"Detail_Favorites"] forState:UIControlStateNormal];
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"Detail_UnFavorites"] forState:UIControlStateNormal];
        }
    
        
        
    }
    else if(button.tag == KButtonTagBase + 2)
    {
        NSString *shareUrl = self.newsDicInfo[@"ShareUrl"];
        NSString *title = self.newsDicInfo[@"Title"];
        if(shareUrl.length > 0)
        {
            NSString *imageUrl = self.newsDicInfo[@"DefaultPicUrl"];
            if(imageUrl.length > 0)
            {
                [self shareUrlByLinkUrl:shareUrl title:title detailTitle:@"" imageUrl:imageUrl];
            }
            else
            {
                [self shareUrlByLinkUrl:shareUrl title:title detailTitle:@"" localImage:nil];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"找不到分享链接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 2;
            [alert show];
        }
        
    }
    
    
    
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"请求url:%@",request.URL.absoluteString);
    return YES;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *documentTitleString = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleStr = documentTitleString;
    [self changeFont];
}



-(void)changeFont
{
    NSArray *list = @[@"大", @"中", @"小"];
    NSString *selectFont = [[NSUserDefaults standardUserDefaults] valueForKey:TX_SETTING_FONT];
    if(selectFont.length <= 0)
    {
        selectFont = @"中";
    }
    NSInteger  index = [list indexOfObject:selectFont];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ChangeFont(\"%@\")", @(index +1)]];
}

@end
