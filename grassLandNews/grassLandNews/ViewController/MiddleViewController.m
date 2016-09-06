//
//  MiddleViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/9/6.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "MiddleViewController.h"
#import "UIView+AlertView.h"

@interface MiddleViewController ()

@end

@implementation MiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavBar];
    self.titleStr = @"首页";
    [self.btnLeft setTitle:@"左侧" forState:UIControlStateNormal];
    [self setupViews];
}

-(void)setupViews
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(50, 100, 80, 40);
}


-(void)press:(id)sender
{
    
    
    ButtonItem *confirmBtn = [ButtonItem itemWithLabel:@"确定" andTextColor:[UIColor redColor] action:^{
        
    }];
    
    [self showAlertViewWithMessage:@"1111111" andButtonItems:confirmBtn, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self presentLeftMenuViewController:sender];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
