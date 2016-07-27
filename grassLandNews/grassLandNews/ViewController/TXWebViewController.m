//
//  TXWebViewController.m
//  TXChatParent
//
//  Created by 陈爱彬 on 16/2/22.
//  Copyright © 2016年 lingiqngwan. All rights reserved.
//

#import "TXWebViewController.h"
#import <NJKWebViewProgressView.h>
#import <NJKWebViewProgress.h>
//#import "TXProgressHUD.h"
//#import <TXChatCommon/UMSocial.h>
//#import <TXChatCommon/UMSocialQQHandler.h>
//#import "TXSystemManager.h"
#import "EasyJSWebView.h"
#import "UIView+Utils.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import <WXApi.h>
//#import <TXChatCommon/UMSocialWechatHandler.h>
//#import "WXYNewListArchiverHelper.h"
#import "Comment.h"

@interface TXWebViewController ()
<UIWebViewDelegate,
NJKWebViewProgressDelegate>
{
    EasyJSWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    BOOL _isBackRequest;
}
@property (nonatomic,copy) NSString *userToken;
@property (nonatomic, strong) NSString *shareUrl;
@end

@implementation TXWebViewController

- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [self init];
    if (self) {
        _urlString = urlString;
        self.shareUrl = nil;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        if ([TXSystemManager sharedManager].isDevVersion) {
//            NSString *baseUrlString = [[TXSystemManager sharedManager] filterHost];
//            _filtedHost = baseUrlString;
//        }else{
            _filtedHost = @"tx2010.com";
//        }
        _requireShare = NO;
        _automaticChangeTitle = YES;
        _shareUrl = nil;
    }
    return self;
}

- (void)setShareUrl:(NSString*)aUrl{
    _shareUrl = aUrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldLimitTitleLabelWidth = YES;
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
//    self.titleLb.frame = CGRectMake(60, 20, self.view.width_ - 120, kNavigationHeight);
    if (IOS7_OR_LATER) {
        self.titleLb.frame = CGRectMake(60, 20, self.view.width_ - 120, kNavigationHeight);
    }else{
        self.titleLb.frame = CGRectMake(60, 0, self.view.width_ - 120, kNavigationHeight);
    }
    //添加分享
    if (_requireShare) {
        [self.btnRight setImage:[UIImage imageNamed:@"bar_share"] forState:UIControlStateNormal];
        //添加关闭按钮
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, self.customNavigationView.height_ - kNavigationHeight, 40, kNavigationHeight)];
        closeBtn.adjustsImageWhenHighlighted = NO;
        closeBtn.titleLabel.font = kFontMiddle;
        closeBtn.exclusiveTouch = YES;
        [closeBtn setTitleColor:kColorNavigationTitle forState:UIControlStateNormal];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onCloseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.customNavigationView addSubview:closeBtn];
        //调整frame
        self.titleLb.frame = CGRectMake(0, 0,self.view.width_ - 200, kNavigationHeight);
        self.titleLb.center = CGPointMake(self.customNavigationView.center.x, self.customNavigationView.height_ - kNavigationHeight / 2);
    }else{
        [self.btnRight setTitle:@"关闭" forState:UIControlStateNormal];
    }
    _webView = [[EasyJSWebView alloc] initWithFrame:CGRectMake(0, self.customNavigationView.maxY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - self.customNavigationView.maxY)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    [_webView addJavascriptInterfaces:[TXWebViewController new] WithName:@"jsObj"];
    //添加进度条
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 4.f;
    CGRect barFrame = CGRectMake(0, self.customNavigationView.maxY, CGRectGetWidth(self.view.frame), progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progress = 0.f;
    //加载网页内容
    [self loadWebContent];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}
#pragma mark - 按钮响应
- (void)onClickBtn:(UIButton *)sender
{
    if (sender.tag == TopBarButtonLeft) {
        if ([_webView canGoBack]) {
            _isBackRequest = YES;
            [_webView goBack];
        }else{
            if (_backToTop) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if (sender.tag == TopBarButtonRight) {
        if (_requireShare) {
            [self shareLinkToSocial];
        }else{
            if (_backToTop) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
- (void)onCloseButtonTapped:(UIButton *)btn
{
    if (_backToTop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  支付宝支付
 */
- (void)signParamsCall:(NSString *)orderString{
//    NSString *appScheme = @"AppPay";
//    if (orderString != nil) {
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }
}

/**
 *  微信支付
 */
- (void)wxRepayCall:(NSString *)orderString{
//    NSDictionary *orderDic = [NSJSONSerialization JSONObjectWithData:[orderString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
//    [UMSocialWechatHandler setWXAppId:orderDic[@"appid"] appSecret:orderDic[@"secret"] url:nil];
//    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = orderDic[@"partnerid"];
//    req.prepayId            = orderDic[@"prepayid"];
//    req.nonceStr            = orderDic[@"noncestr"];
//    req.timeStamp           = [orderDic[@"timestamp"] doubleValue];
//    req.package             = orderDic[@"package"];
//    
//    NSMutableDictionary *rdict = [NSMutableDictionary dictionary];
//    [rdict setObject:orderDic[@"appid"] forKey:@"appid"];
//    [rdict setObject:req.partnerId forKey:@"partnerid"];
//    [rdict setObject:req.prepayId forKey:@"prepayid"];
//    [rdict setObject:req.nonceStr forKey:@"noncestr"];
//    [rdict setObject:[NSString stringWithFormat:@"%u",(unsigned int)req.timeStamp] forKey:@"timestamp"];
//    [rdict setObject:req.package forKey:@"package"];
//    
//    //    NSDictionary *result = [WXApiManager partnerSignOrder:rdict];
//    req.sign                = orderDic[@"sign"];
//    //    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",orderDic[@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//    
//    [WXApi sendReq:req];
}

#pragma mark - 分享
- (void)shareLinkToSocial
{
//    if (!_urlString && ![_urlString length]) {
//        return;
//    }
//    if (_shareUrl!=nil) {
//        [self shareToSocialWithLink:_shareUrl title:self.titleStr detailTitle:self.titleStr];
//    }else{
//        [self shareToSocialWithLink:_urlString title:self.titleStr detailTitle:self.titleStr];
//    }
    
}
#pragma mark - 内容加载
- (void)loadWebContent
{
    if (!_urlString || ![_urlString length]) {
        return;
    }
    NSString *requestUrl = _urlString;
//    NSDictionary *dict = [[TXChatClient sharedInstance] getCurrentUserProfiles:nil];
//    if (dict) {
        self.userToken = @"123456";
        //添加到url后token字段
        if ([requestUrl containsString:_filtedHost]) {
//            requestUrl = @"http://101.200.139.197/jiaofei.do?";
            if (IOS7_OR_LATER) {
                NSURLComponents *components = [NSURLComponents componentsWithString:requestUrl];
                NSString *query = [components query];
                if (query && [query length]) {
                    //存在query
                    NSString *lastChar = [query substringFromIndex:[query length] - 1];
                    if ([lastChar isEqualToString:@"&"]) {
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"token=%@",self.userToken]];
                    }else{
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"&token=%@",self.userToken]];
                    }
                }else{
                    //不存在query
                    NSString *lastChar = [requestUrl substringFromIndex:[requestUrl length] - 1];
                    if ([lastChar isEqualToString:@"?"]) {
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"token=%@",self.userToken]];
                    }else{
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"?token=%@",self.userToken]];
                    }
                }
            }else{
                if ([requestUrl containsString:@"?"]) {
                    //存在query
                    NSString *lastChar = [requestUrl substringFromIndex:[requestUrl length] - 1];
                    if ([lastChar isEqualToString:@"&"]) {
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"token=%@",self.userToken]];
                    }else{
                        requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"&token=%@",self.userToken]];
                    }
                }else{
                    //不存在query
                    requestUrl = [requestUrl stringByAppendingString:[NSString stringWithFormat:@"?token=%@",self.userToken]];
                }
            }
//            NSLog(@"requestUrl:%@",requestUrl);
        }
    
    [self startRequestWithUserTokenByUrlString:requestUrl headerDict:nil];

}
//带上token开始请求
- (void)startRequestWithUserTokenByUrlString:(NSString *)urlString
                                  headerDict:(NSDictionary *)dict
{
    if (!urlString) {
        return;
    }
    //修改token
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.f];
    if (dict) {
        //设置header
        [request setAllHTTPHeaderFields:dict];
    }
//    NSLog(@"之前header:%@",request.allHTTPHeaderFields);
    if (self.userToken) {
        [request setValue:self.userToken forHTTPHeaderField:@"token"];
    }
//    NSLog(@"之后header:%@",request.allHTTPHeaderFields);
    [_webView loadRequest:request];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    //    NSLog(@"progress:%@",@(progress));
    [_progressView setProgress:progress animated:YES];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"请求url:%@",request.URL.absoluteString);
//    NSLog(@"请求header:%@",request.allHTTPHeaderFields);
    if (_isBackRequest) {
        _isBackRequest = NO;
        return YES;
    }
    return YES;
//    //非土星的网页不拦截
//    if ([TXSystemManager sharedManager].isDevVersion) {
//        NSURL *baseUrl = [NSURL URLWithString:[[TXSystemManager sharedManager] webBaseUrlString]];
//        if (![request.URL.absoluteString containsString:[baseUrl host]]) {
//            return YES;
//        }
//    }else{
//        if (![request.URL.absoluteString containsString:_filtedHost]) {
//            return YES;
//        }
//    }
//    NSDictionary *headerDict = request.allHTTPHeaderFields;
//    if ([request valueForHTTPHeaderField:@"token"]) {
//        return YES;
//    }
//    NSString *urlString = request.URL.absoluteString;
//    [self startRequestWithUserTokenByUrlString:urlString headerDict:headerDict];
//    return NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //标记为已读
//    BOOL a = [[WXYNewListArchiverHelper shareInstance] isRead:_urlString];
//    if (a==NO) {
//        [[WXYNewListArchiverHelper shareInstance] addFile:_urlString];
//    }
    //获取网页的标题
    if (_automaticChangeTitle) {
        NSString *documentTitleString = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.titleStr = documentTitleString;
    }
    

}
@end
