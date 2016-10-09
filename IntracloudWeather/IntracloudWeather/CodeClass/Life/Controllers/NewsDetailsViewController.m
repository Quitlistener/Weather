//
//  NewsDetailsViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import <WebKit/WebKit.h>

@interface NewsDetailsViewController ()
@property (nonatomic, strong) WKWebView *newsWebiew;

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    if (SCREEN_width == 320) {
        self.newsWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, -44, SCREEN_width, SCREENH_height+44)];
    }
    else if (SCREEN_width == 375){
        self.newsWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, -50, SCREEN_width, SCREENH_height+50)];
    }
    else{
        self.newsWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, -54, SCREEN_width, SCREENH_height+54)];
    }
    
    
    [self.newsWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URLstr]]];
    [self.view addSubview:_newsWebiew];
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
