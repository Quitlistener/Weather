//
//  SceneryDetailViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/11.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SceneryDetailViewController.h"
#import <WebKit/WebKit.h>
//#import "MBProgressHUD.h"

#define WKremoveAD(str) ([NSString stringWithFormat:@"document.getElementsByClassName('%@')[0].style.display = 'none'",(str)] )

@interface SceneryDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) UIView *backGroundView;

@property (nonatomic, strong) WKWebView *WKWebiew;
@property (nonatomic, strong) NSArray *arrayAD;

//@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation SceneryDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _dbManager = [[ReadDetailDBManager defaultManager]init];
//    [_dbManager createTable];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.arrayAD = @[@"tit",@"e_crumb",@"e_banner",@"tool-zan icon",@"tool-comment icon",@"tool-share icon",@"comment",@"relevant-img",@"relevant-list",@"main_nav_wrapper",@"titles relevant-titles",@"footer_nav clearfix",@"mobile_pc clearfix",@"copyright",@"tool-back icon",@"e_banner_bg",@"t_author",@"info-bar"];
    
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(TapLeftBackAction)];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 7;
    self.backGroundView.userInteractionEnabled = YES;
    
    self.WKWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    [self.WKWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL]]];
    self.WKWebiew.navigationDelegate = self;
    self.WKWebiew.UIDelegate = self;
    [self.backGroundView addSubview:_WKWebiew];
    [self.view addSubview:self.backGroundView];
    NSLog(@">>>>>>>>>>>%@",_strURL);
}


#pragma mark -WKWebView代理
// 当内容commit时触发该方法
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
/** 页面加载完成后触发该方法 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    for (int i = 1; i < self.arrayAD.count; i++) {
        [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i]) completionHandler:^(id item, NSError * _Nullable error) {
            
        }];
    }
}


/** 返回 */
-(void)TapLeftBackAction{
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
