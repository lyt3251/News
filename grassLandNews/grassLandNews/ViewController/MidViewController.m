//
//  MidViewController.m
//  grassLandNews
//
//  Created by liuyuantao on 16/7/27.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import "MidViewController.h"

@interface MidViewController ()

@end

@implementation MidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomNavBar];
    self.titleStr = @"中间";
    [self.btnLeft setTitle:@"左边" forState:UIControlStateNormal];
//    self.btnLeft.titleLabel.textColor = [UIColor redColor];
    [self.btnLeft setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self setupViews];
    // Do any additional setup after loading the view.
}

-(void)setupViews
{
    self.view.backgroundColor = [UIColor greenColor];
    
    

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
