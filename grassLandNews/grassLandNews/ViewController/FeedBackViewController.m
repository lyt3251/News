//
//  FeedBackViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CHSCharacterCountTextView.h"
#import "FeedBackManager.h"

@interface FeedBackViewController ()<UIScrollViewDelegate, UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    UIView *_contentView;//滚动条内的view;
}
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)CHSCharacterCountTextView *inputTextView;
@property(nonatomic, strong)UILabel *subTitleLabel;
@property(nonatomic, strong)UITextField *addressTextView;
@property (nonatomic) CGFloat keyboardHeight;               // 键盘高度
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    self.titleStr = @"我要反馈";
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    [self.btnRight setTitle:@"发送" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

-(void)setupViews
{
    UIScrollView *scrollView = UIScrollView.new;
    _scrollView = scrollView;
    _scrollView.delegate = self;
    scrollView.backgroundColor = kColorBackground;
    [self.view addSubview:scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(self.customNavigationView.maxY, 0, 0, 0));
    }];
    UIView* contentView = UIView.new;
    [contentView setBackgroundColor:kColorBackground];
    _contentView = contentView;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = RGBCOLOR(0x22, 0x22, 0x22);
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.text = @"请输入您的意见和建议:";
    [_contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo( 25);
        make.right.mas_equalTo(-15);
    }];
    
    UIView *inputBackView = [[UIView alloc] init];
    inputBackView.layer.borderColor = KColorBorderColor.CGColor;
    inputBackView.layer.borderWidth = 0.5f;
    inputBackView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:inputBackView];
    [inputBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(150);
    }];
    

    self.inputTextView = [[CHSCharacterCountTextView alloc] initWithMaxNumber:500 placeHoder:@"我们会认真记录并在后续的版本中作出针对性的优化和改进~"];
    self.inputTextView.backgroundColor = [UIColor clearColor];
    [inputBackView addSubview:self.inputTextView];
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = RGBCOLOR(0x22, 0x22, 0x22);
    self.subTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.subTitleLabel.text = @"请输入您的联系方式:";
    [_contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.inputTextView.mas_bottom).with.offset(20);
        make.right.mas_equalTo(0);
    }];
    
    self.addressTextView = [[UITextField alloc] init];
    self.addressTextView.placeholder = @"QQ/电话/邮箱均可";
    self.addressTextView.layer.borderColor = KColorBorderColor.CGColor;
    self.addressTextView.layer.borderWidth = 0.5f;
    self.addressTextView.backgroundColor = [UIColor whiteColor];
    self.addressTextView.delegate = self;
    self.addressTextView.font = [UIFont systemFontOfSize:14];
    [_contentView addSubview:self.addressTextView];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subTitleLabel);
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).with.offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.addressTextView.mas_bottom);
    }];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDown:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapGesture];

}


-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(sender.tag == TopBarButtonRight)
    {
        
        NSString *content = [self.inputTextView getContent];
        NSString *contact = [self.addressTextView text];
        
        if(contact.length <= 0)
        {
            [self showSuccessHudWithTitle:@"请输入反馈内容"];
            return;
        }
        if(contact.length <= 0)
        {
            [self showSuccessHudWithTitle:@"请输入联系方式"];
            return;
        }
        
        
        FeedBackManager *feedManager = [[FeedBackManager alloc] init];
        @weakify(self);
        [feedManager sendFeedInfoByContent:content withContact:contact onCompleted:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSNumber *status = dic[@"status"];
            if(status.integerValue > 0)
            {
                [self showSuccessHudWithTitle:@"反馈成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                if(error)
                {
                    [self showFailedHudWithError:error];
                }
                else
                {
                    [self showFailedHudWithTitle:dic[@"msg"]];
                }
            }
            
            
        }];
        
    
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
- (void)keyboardDown:(UITapGestureRecognizer *)recognizer
{
    //去除键盘
    if(self.inputTextView.isFirstResponder)
    {
        [self.inputTextView resignFirstResponder];
    }
    
    if(self.addressTextView.isFirstResponder)
    {
        [self.addressTextView resignFirstResponder];
    }
}

#pragma mark-- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘高度 和 动画速度
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animateSpeed = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 过滤重复
    if (_keyboardHeight == keyboardHeight)
        return;
    _keyboardHeight = keyboardHeight;
    
    UIView *vFirstResponder = [self.view subviewWithFirstResponder];
    CGRect vFirstResponderRect = [_scrollView convertRect:vFirstResponder.frame fromView:vFirstResponder.superview];
    vFirstResponderRect.origin.y = vFirstResponderRect.origin.y - _scrollView.contentOffset.y; // 标题栏占位偏移
    
    if (vFirstResponder) {
        [UIView animateWithDuration:animateSpeed animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, 0, keyboardHeight, 0);
            _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
            CGFloat offsetHeight = _scrollView.height_ - keyboardHeight - (vFirstResponderRect.origin.y + vFirstResponderRect.size.height);
            if(offsetHeight < 0)
                _scrollView.contentOffset = CGPointMake(0, _scrollView.contentOffset.y - offsetHeight); // 标题栏占位偏移
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_keyboardHeight == 0)
        return;
    
    // 获取键盘高度 和 动画速度
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animateSpeed = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    _keyboardHeight = 0;
    
    [UIView animateWithDuration:animateSpeed animations:^{
        _scrollView.contentInset = UIEdgeInsetsMake(_scrollView.contentInset.top, 0, 0, 0);
        _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
    }];
}

-(void)addNotification
{
    // 键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
