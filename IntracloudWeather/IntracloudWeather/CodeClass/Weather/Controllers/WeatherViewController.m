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
#import "NetWorkRequest.h"
#import "XYtodayCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "Definition.h"
//#import "PopupView.h"
#import "AlertView.h"
#import "TTSConfig.h"

@interface WeatherViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,IFlySpeechSynthesizerDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LeftWeatherDetailsView *left;
@property (nonatomic, strong) RightWeatherDetailsView *right;
@property (nonatomic, strong) CurrentWeatherDetailsView *current;
@property (weak, nonatomic) IBOutlet UIButton *XYCity;
@property (nonatomic, strong) TodayWeatherView *todayView;
@property (nonatomic, strong) TomorrowWwatherView *tomorrowView;
@property (nonatomic, strong) ThirddayWeatherView *thirddayVeiw;
@property (nonatomic, strong) UICollectionView *XYcollection;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self initUI];
    [self requestData];
}
#pragma mark -初始化UI
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
    
    /*
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
    */
     
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_width-40)/3,(100-20));
    //设置每个item的间距
    flowLayout.minimumInteritemSpacing = 5;
    //设置CollectionView的item距离屏幕上左下右的间距(默认都是10)
    flowLayout.sectionInset = UIEdgeInsetsMake(10 , 10, 10, 10);
    //设置每个item的行间距(默认是10.0)
//    flowLayout.minimumLineSpacing = 3;
    _XYcollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREENH_height-100, SCREEN_width, 100) collectionViewLayout:flowLayout];
    [_XYcollection registerNib:[UINib nibWithNibName:@"XYtodayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XYcollection"];
    _XYcollection.backgroundColor = [UIColor clearColor];
    _XYcollection.delegate = self;
    _XYcollection.dataSource = self;
    [self.view addSubview:_XYcollection];
    

}

#pragma mark -网路请求
-(void)requestData{
//    [NetWorkRequest requestWithMethod:GET URL:<#(NSString *)#> para: success:<#^(NSData *data)suc#> error:<#^(NSError *error)failerror#>]
}

#pragma mark -collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYtodayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYcollection" forIndexPath:indexPath];
    return cell;
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

//- (IBAction)tapVoice:(id)sender {
//    _iFlySpeechSynthesizer.delegate = self;
//    NSString* str = @"啦啦啦可以了";
//    [_iFlySpeechSynthesizer startSpeaking:str];
//    if (_iFlySpeechSynthesizer.isSpeaking) {
//        _state = Playing;
//    }
//}


#pragma mark -讯飞
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSynthesizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.isViewDidDisappear = true;
    [_iFlySpeechSynthesizer stopSpeaking];
    [_audioPlayer stop];
    [_inidicateView hide];
    _iFlySpeechSynthesizer.delegate = nil;
}

#pragma mark - 设置合成参数
- (void)initSynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    _iFlySpeechSynthesizer.delegate = self;
    //设置语速1-100
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    NSString* textSample=nil;
    textSample=NSLocalizedStringFromTable(@"text_chinese", @"tts/tts", nil);
}

#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 ****/
- (void)onSpeakBegin
{
    [_inidicateView hide];
    self.isCanceled = NO;
    if (_state  != Playing) {
    }
    _state = Playing;
}

- (void)onCompleted:(IFlySpeechError *) error{
    
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
