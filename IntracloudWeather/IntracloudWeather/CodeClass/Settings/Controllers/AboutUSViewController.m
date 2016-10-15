//
//  AboutUSViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/12.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(LeftBackAction)];
    /** 手势 */
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)LeftBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapBackAction:(UITapGestureRecognizer *)tap{
   [self dismissViewControllerAnimated:YES completion:^{
       
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

@end
