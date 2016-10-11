//
//  SceneryDetailViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/11.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SceneryDetailViewController.h"

@interface SceneryDetailViewController ()
@property (strong, nonatomic) UIView *backGroundView;

@end

@implementation SceneryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_width-20  , SCREENH_height- 20)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 7;
    self.backGroundView.userInteractionEnabled = YES;
    [self.view addSubview:self.backGroundView];
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

@end
