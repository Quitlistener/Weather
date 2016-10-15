//
//  SceneryDetailViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/11.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SceneryDetailViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "Monitor.h"

#define WKremoveAD(str) ([NSString stringWithFormat:@"document.getElementsByClassName('%@')[0].style.display = 'none'",(str)] )

@interface SceneryDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) UIView *backGroundView;

@property (nonatomic, strong) WKWebView *WKWebiew;
@property (nonatomic, strong) NSArray *arrayAD;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *shadeView;
@end

@implementation SceneryDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.arrayAD = @[@"tit",@"e_crumb",@"e_banner",@"tool-zan icon",@"tool-comment icon",@"tool-share icon",@"comment",@"relevant-img",@"relevant-list",@"main_nav_wrapper",@"titles relevant-titles",@"footer_nav clearfix",@"mobile_pc clearfix",@"copyright",@"tool-back icon",@"e_banner_bg",@"t_author",@"info-bar",@"user_name_icon"];
    self.arrayAD = @[@"b_banner",@"b_crumb",@"tool",@"t_author",@"user_name_icon",@"comment",@"relevant-list",@"qn_footer",@"titles relevant-titles"];
    
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(TapLeftBackAction)];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 7;
    self.backGroundView.userInteractionEnabled = YES;
   
    
    self.WKWebiew = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    self.WKWebiew.navigationDelegate = self;
    self.WKWebiew.UIDelegate = self;
    _shadeView = [[UIView alloc]initWithFrame:self.view.frame];
    _shadeView.backgroundColor = [UIColor whiteColor];
    [self.WKWebiew addSubview:_shadeView];
    _hud = [MBProgressHUD showHUDAddedTo:self.shadeView animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text = @"Loading...";
    [self.WKWebiew loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL]]];
    [self.backGroundView addSubview:_WKWebiew];
    [self.view addSubview:self.backGroundView];
    NSLog(@">>>>%@",_strURL);
}


#pragma mark -WKWebView代理
/** 开始加载页面调用 */
/** 开始请求 */
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [Monitor monitorWithView:self.view];
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"++1");
//    for (int i = 0; i < _arrayAD.count; i++) {
//        [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i]) completionHandler:^(id item, NSError * _Nullable error) {
//        }];
//    }
//        /** 去掉广告后删除隐藏内容的View */
//        [_shadeView removeFromSuperview];
//        //隐藏正在加载
//        [self.hud hideAnimated:YES];
//        [_WKWebiew stopLoading];
    
}

/** 页面加载完成后触发该方法 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"++2");
    for (int i = 0; i < 5; i++) {
        [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i]) completionHandler:^(id item, NSError * _Nullable error) {
        }];
    }
    /** 去掉广告后删除隐藏内容的View */
    [_shadeView removeFromSuperview];
    //隐藏正在加载
    [self.hud hideAnimated:YES];
    
    for (int i = 0; i < 4; i++) {
        [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i+5]) completionHandler:^(id item, NSError * _Nullable error) {
        }];
    }
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i]) completionHandler:^(id item, NSError * _Nullable error) {
            }];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 4; i++) {
//            NSLog(@"2******%@",[NSThread currentThread]);
            [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i+3]) completionHandler:^(id item, NSError * _Nullable error) {
            }];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 4; i++) {
//            NSLog(@"3******%@",[NSThread currentThread]);
            [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i+7]) completionHandler:^(id item, NSError * _Nullable error) {
            }];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 4; i++) {
//            NSLog(@"4******%@",[NSThread currentThread]);
            [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i+11]) completionHandler:^(id item, NSError * _Nullable error) {
            }];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 4; i++) {
//            NSLog(@"5******%@",[NSThread currentThread]);
            [self.WKWebiew evaluateJavaScript:WKremoveAD(_arrayAD[i+15]) completionHandler:^(id item, NSError * _Nullable error) {
            }];
        }
    });
    */
//    /** 去掉广告后删除隐藏内容的View */
//    [_shadeView removeFromSuperview];
//    //隐藏正在加载
//    [self.hud hideAnimated:YES];
    [_WKWebiew stopLoading];
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
