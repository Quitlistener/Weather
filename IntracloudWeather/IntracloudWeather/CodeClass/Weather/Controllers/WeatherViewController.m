//
//  WeatherViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "WeatherViewController.h"
#import "LeftWeatherDetailsView.h"
#import "RightWeatherDetailsView.h"
#import "CurrentWeatherDetailsView.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "TodayWeatherView.h"
#import "TomorrowWwatherView.h"
#import "ThirddayWeatherView.h"

@interface WeatherViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LeftWeatherDetailsView *left;
@property (nonatomic, strong) RightWeatherDetailsView *right;
@property (nonatomic, strong) CurrentWeatherDetailsView *current;
@property (weak, nonatomic) IBOutlet UIButton *XYCity;
@property (nonatomic, strong) TodayWeatherView *todayView;
@property (nonatomic, strong) TomorrowWwatherView *tomorrowView;
@property (nonatomic, strong) ThirddayWeatherView *thirddayVeiw;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self initUI];
}

-(void)initUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_width, SCREENH_height-64 - 100)];
    //设置滚动条的滚动范围
    _scrollView.contentSize = CGSizeMake(SCREEN_width * 3, 0);
    _scrollView.contentOffset = CGPointMake(SCREEN_width, 0);
    //水平滚动条隐藏
    _scrollView.showsHorizontalScrollIndicator = NO;
    //垂直滚动条隐藏
    _scrollView.showsVerticalScrollIndicator = NO;
    //分页滚动
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    _left = [[NSBundle mainBundle]loadNibNamed:@"LeftWeatherDetailsView" owner:nil options:nil][0];
    _left.frame = CGRectMake(0, 0, SCREEN_width, SCREENH_height-64 - 100);
    _left.backgroundColor = [UIColor clearColor];
    _right = [[NSBundle mainBundle]loadNibNamed:@"RightWeatherDetailsView" owner:nil options:nil][0];
    _right.frame = CGRectMake(SCREEN_width*2, 0, SCREEN_width, SCREENH_height-64 - 100);
    _right.backgroundColor = [UIColor clearColor];
    _current = [[NSBundle mainBundle]loadNibNamed:@"CurrentWeatherDetailsView" owner:nil options:nil][0];
    _current.frame = CGRectMake(SCREEN_width, 0, SCREEN_width, SCREENH_height-64 - 100);
    _current.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_left];
    [_scrollView addSubview:_right];
    [_scrollView addSubview:_current];
    [self.view addSubview:_scrollView];
    [_XYCity setImage:[UIImage imageNamed:@"加号16.png"] forState:UIControlStateNormal];
    
    _todayView = [[NSBundle mainBundle]loadNibNamed:@"TodayWeatherView" owner:nil options:nil][0];
    _todayView.frame = CGRectMake(10, SCREENH_height-100, SCREEN_width/3-60, 90);
    _todayView.backgroundColor = [UIColor clearColor];
    _tomorrowView = [[NSBundle mainBundle]loadNibNamed:@"TomorrowWwatherView" owner:nil options:nil][0];
    _tomorrowView.frame = CGRectMake(SCREEN_width/3+10+10, SCREENH_height-100, SCREEN_width/3-60, 90);
    _tomorrowView.backgroundColor = [UIColor clearColor];
    _thirddayVeiw = [[NSBundle mainBundle]loadNibNamed:@"ThirddayWeatherView" owner:nil options:nil][0];
    _thirddayVeiw.frame = CGRectMake((SCREEN_width/3)*2+10, SCREENH_height-100, SCREEN_width/3-60, 90);
    _thirddayVeiw.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_todayView];
    [self.view addSubview:_tomorrowView];
    [self.view addSubview:_thirddayVeiw];
    

}

#pragma mark -scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateView];
    [_scrollView setContentOffset:CGPointMake(SCREEN_width, 0) animated:NO];
}

-(void)updateView{
    
}

#pragma mark -点击事件
- (IBAction)tapAddCity:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (IBAction)tapLeftMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)tapShare:(UIButton *)sender {
    
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
