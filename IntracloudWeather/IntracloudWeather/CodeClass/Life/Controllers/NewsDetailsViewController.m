//
//  NewsDetailsViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

#define WKremoveAD(str) ([NSString stringWithFormat:@"document.getElementsByClassName('%@')[0].style.display = 'none'",(str)] )

@interface NewsDetailsViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *newsWebiew;
@property (nonatomic, strong) NSArray *newsAD;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *shadeView;

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsAD = @[@"share_mask js-share-mask",@"topbar",@"a_adtemp a_topad js-topad",@"back_to_top",@"go_index",@"more_client more-client ",@"templet",@"relative_doc",@"hot_news",@"foot_nav",@"copyright",@"relative_doc"];
    [self initUI];
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(tapBackAction)];
    NSLog(@">>>>>>>%ld",_newsAD.count);
}

-(void)initUI{
    self.newsWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, -44, SCREEN_width, SCREENH_height+44)];
    self.newsWebiew.UIDelegate = self;
    self.newsWebiew.navigationDelegate = self;
    _shadeView = [[UIView alloc]initWithFrame:self.view.frame];
    _shadeView.backgroundColor = [UIColor whiteColor];
     [self.newsWebiew addSubview:_shadeView];
    _hud = [MBProgressHUD showHUDAddedTo:self.shadeView animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text = @"Loading...";
    [self.newsWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URLstr]]];
    [self.view addSubview:_newsWebiew];
}

#pragma mark -WKWebiew代理
/** 页面加载完成后触发该方法 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    int a = 0;
    for (int i = 1; i < self.newsAD.count; i++) {
        [self.newsWebiew evaluateJavaScript:WKremoveAD(_newsAD[i]) completionHandler:^(id item, NSError * _Nullable error) {
           
        }];
         a++;
    }
    [_shadeView removeFromSuperview];
    //隐藏正在加载
    [self.hud hideAnimated:YES];
    NSLog(@"%d",a);
}


//-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSLog(@">>>>>");
//}


/** 返回 */
-(void)tapBackAction{
    [self.navigationController popViewControllerAnimated:YES];
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
