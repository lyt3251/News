//
//  AboutViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/8/4.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController()
@end

@implementation AboutViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self createCustomNavBar];
    self.customNavigationView.backgroundColor = KColorAppMain;
    self.titleStr = @"关于我们";
    [self.btnLeft setImage:[UIImage imageNamed:@"Main_Back"] forState:UIControlStateNormal];
    [self setupViews];
}


-(void)setupViews
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kColorBackground;
    headerView.frame = CGRectMake(0, self.customNavigationView.maxY, kScreenWidth, 5.0f);
    [self.view addSubview:headerView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = kFontNewsTitle;
    label1.textColor = kColorNewsTitle;
    label1.text = @"农业部草原监理中心";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(55);
        make.top.mas_equalTo(headerView.mas_bottom).with.offset(80.0f);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = kFontNewsSubTitle;
    label2.textColor = kColorNewsChannel;
    label2.text = @"联系信箱：";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1);
        make.top.mas_equalTo(label1.mas_bottom).with.offset(33);
        make.width.mas_equalTo(75);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.font = kFontNewsSubTitle;
    label3.textColor = kColorNewsTitle;
    label3.text = @"grassland@agri.gov.cn";
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label2.mas_right);
        make.centerY.mas_equalTo(label2);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.font = kFontNewsSubTitle;
    label4.textColor = kColorNewsChannel;
    label4.text = @"联系地址：";
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1);
        make.top.mas_equalTo(label2.mas_bottom).with.offset(20);
        make.width.mas_equalTo(75);
    }];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.font = kFontNewsSubTitle;
    label5.textColor = kColorNewsTitle;
    label5.text = @"北京市朝阳区农展南里11号";
    [self.view addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label4.mas_right);
        make.centerY.mas_equalTo(label4);
        make.right.mas_equalTo(0);
    }];
    

    UILabel *label6 = [[UILabel alloc] init];
    label6.font = kFontNewsSubTitle;
    label6.textColor = kColorNewsChannel;
    label6.text = @"邮       编：";
    [self.view addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1);
        make.top.mas_equalTo(label4.mas_bottom).with.offset(20);
        make.width.mas_equalTo(75);
    }];
    
    UILabel *label7 = [[UILabel alloc] init];
    label7.font = kFontNewsSubTitle;
    label5.textColor = kColorNewsTitle;
    label7.text = @"100125";
    [self.view addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label6.mas_right);
        make.centerY.mas_equalTo(label6);
        make.right.mas_equalTo(0);
    }];
    
    UILabel *label8 = [[UILabel alloc] init];
    label8.font = kFontNewsSubTitle;
    label8.textColor = kColorNewsChannel;
    label8.text = @"网       址：";
    [self.view addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1);
        make.top.mas_equalTo(label6.mas_bottom).with.offset(20);
        make.width.mas_equalTo(75);
    }];
    
    UILabel *label9 = [[UILabel alloc] init];
    label9.font = kFontNewsSubTitle;
    label9.textColor = kColorNewsTitle;
    label9.text = @"http://www.grassland.gov.cn";
    [self.view addSubview:label9];
    [label9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label8.mas_right);
        make.centerY.mas_equalTo(label8);
        make.right.mas_equalTo(0);
    }];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void)onClickBtn:(UIButton *)sender
{
    if(sender.tag == TopBarButtonLeft)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self presentLeftMenuViewController:sender];
    }
}



@end
