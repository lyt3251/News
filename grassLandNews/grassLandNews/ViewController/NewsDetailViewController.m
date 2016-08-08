//
//  NewsDetailViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/7.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "NewsDetailViewController.h"


#define KBottomBarHight  55.0f
#define KButtonTagBase 0x1000

@interface NewsDetailViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)NSString *urlStr;
@end

@implementation NewsDetailViewController

-(id)initWithUrl:(NSString *)url
{
    self = [super init];
    if(self)
    {
        _urlStr = url;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    
    [self setupViews];
    
}

-(void)setupViews
{
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(self.customNavigationView.maxY, 0, -KBottomBarHight, 0));
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
            iconName = @"Detail_Favorites";
        }
        else if (i == 2)
        {
            iconName = @"Detail_Share";
        }
        
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    
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
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(void)bottomBtnClick:(UIButton *)button
{
    if(button.tag == KButtonTagBase)
    {
        NSLog(@"字体被按下");
    }
    else if(button.tag == KButtonTagBase + 1)
    {
        NSLog(@"收藏被按下");
    }
    else if(button.tag == KButtonTagBase + 2)
    {
        NSLog(@"分享被按下");
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
}


@end
