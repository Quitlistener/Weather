//
//  WeatherViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "WeatherViewController.h"
#import "CurrentWeatherDetailsView.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "NetWorkRequest.h"
#import "XYtodayCollectionViewCell.h"
#import "userInfoModel.h"
#import "Monitor.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "Definition.h"
//#import "PopupView.h"
#import "AlertView.h"
#import "TTSConfig.h"
#import "WeatherBaseClass.h"
#import "CityDetailDBManager.h"
#import "CityInfoDataModels.h"
#import "UConstants.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"


#define SNOW_IMAGENAME         @"snow"

#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25


@interface WeatherViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,IFlySpeechSynthesizerDelegate,UIActionSheetDelegate,reloadData>
{
    NSMutableArray *_CitysDataArr;
    NSMutableArray *_dailyForecastArr;
    NSMutableString *_voiceStr;
    NSMutableArray *_imagesArray;
    NSInteger _index_Code;
    int _imgWidth_Max ;
    int _imgWidth_Min ;
    UIImageView *_sunnyDayImag;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CurrentWeatherDetailsView *current;
@property (weak, nonatomic) IBOutlet UIButton *XYCity;
@property (weak, nonatomic) IBOutlet UIImageView *XYFrontImageView;
@property (nonatomic, strong) UICollectionView *XYcollection;
@property (nonatomic, strong) userInfoModel *userModer;
@property (nonatomic, strong) WeatherBaseClass *weathBase;

@end

@implementation WeatherViewController

-(void)reloadData{
    [_scrollView removeFromSuperview];
    [_XYcollection removeFromSuperview];
    [self loadCitysData];
    [self initUI];
    userInfoModel *userInfo = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
    NSInteger index = [userInfo.index integerValue];
    [self dataRequestWithCityid:userInfo.cityInfoIdentifier tag:index+10];
    for (int i = 0 ; i < _CitysDataArr.count; i ++) {
        if (i == (int)index) {
            continue;
        }
        CityInfoCityInfo *city = (CityInfoCityInfo *)_CitysDataArr[i];
        [self dataRequestWithCityid:city.cityInfoIdentifier tag:i+10];
    }
    [_XYcollection reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myDelegate.delegate_reload = self;
    __weak typeof(self)weakSelf = self;
    myDelegate.reloadBlock = ^{
        [weakSelf reloadData];
    };
    [self loadCitysData];
    [self initUI];
    userInfoModel *userInfo = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
    NSInteger index = [userInfo.index integerValue];
    [self dataRequestWithCityid:userInfo.cityInfoIdentifier tag:index+10];
    for (int i = 0 ; i < _CitysDataArr.count; i ++) {
        if (i == (int)index) {
            continue;
        }
        CityInfoCityInfo *city = (CityInfoCityInfo *)_CitysDataArr[i];
        [self dataRequestWithCityid:city.cityInfoIdentifier tag:i+10];
    }
    //    [self viewWillAppear:YES];
}
-(void)loadCitysData{
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _CitysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
}
#pragma mark -初始化UI
-(void)initUI{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_width, SCREENH_height-64 - 100)];
    //设置滚动条的滚动范围
    _scrollView.contentSize = CGSizeMake(SCREEN_width * _CitysDataArr.count, 0);
    NSArray *currentCitys = [[CityDetailDBManager defaultManager]selectCityData];
    userInfoModel *model = (userInfoModel *)currentCitys.firstObject;
    if (model) {
        NSInteger index = [model.index integerValue];
        _scrollView.contentOffset = CGPointMake(SCREEN_width*index, 0);
        self.navigationItem.title = model.city;
    }
    else{
        _scrollView.contentOffset = CGPointMake(SCREEN_width, 0);
    }
    //水平滚动条隐藏
    _scrollView.showsHorizontalScrollIndicator = NO;
    //垂直滚动条隐藏
    _scrollView.showsVerticalScrollIndicator = NO;
    //分页滚动
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < _CitysDataArr.count; i++) {
        _current = [[NSBundle mainBundle]loadNibNamed:@"CurrentWeatherDetailsView" owner:nil options:nil][0];
        _current.frame = CGRectMake(SCREEN_width*i, 0, SCREEN_width-1, SCREENH_height-64 - 100);
        _current.tag = i + 10;
        [_current.XYVoiceBtn addTarget:self action:@selector(VoiceBtn) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_current];
    }
    
    [self.view addSubview:_scrollView];
    
    [_XYCity setImage:[UIImage imageNamed:@"加号16.png"] forState:UIControlStateNormal];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_width-40)/3,(100-20));
    //设置每个item的间距
    flowLayout.minimumInteritemSpacing = 5;
    //设置CollectionView的item距离屏幕上左下右的间距(默认都是10)
    flowLayout.sectionInset = UIEdgeInsetsMake(10 , 10, 10, 10);
    //设置每个item的行间距(默认是10.0)
    //    flowLayout.minimumLineSpacing = 3;
    if (model.cityInfoIdentifier) {
        NSInteger index = [model.index integerValue];
        [self dataRequestWithCityid:model.cityInfoIdentifier tag:index + 10];
    }
    _XYcollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREENH_height-100, SCREEN_width, 100) collectionViewLayout:flowLayout];
    [_XYcollection registerNib:[UINib nibWithNibName:@"XYtodayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XYcollection"];
    _XYcollection.backgroundColor = [UIColor clearColor];
    _XYcollection.delegate = self;
    _XYcollection.dataSource = self;
    [self.view addSubview:_XYcollection];
    
    
    
}

#pragma mark -网络请求
-(void)dataRequestWithCityid:(NSString *)cityid tag:(NSInteger )tag{
    [Monitor monitorWithView:self.view];
    NSString *urlStr = [NSString stringWithFormat:@"http://apis.baidu.com/heweather/weather/free?cityid=%@",cityid];
    [NetWorkRequest requestWithMethod:GET URL:urlStr para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (dic[@"HeWeather data service 3.0"]) {
            _weathBase = [WeatherBaseClass modelObjectWithDictionary:dic];
            WeatherHeWeatherDataService30 *HeWeatherDataService30 = [_weathBase heWeatherDataService30].firstObject;
            _dailyForecastArr = [NSMutableArray arrayWithArray:[HeWeatherDataService30 dailyForecast]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *currentCitys = [[CityDetailDBManager defaultManager]selectCityData];
                userInfoModel *model = (userInfoModel *)currentCitys.firstObject;
                NSInteger currentCityIndex = [model.index integerValue];
                
                if (HeWeatherDataService30.dailyForecast.count > 0) {
                    CurrentWeatherDetailsView *view = [_scrollView viewWithTag:tag];
                    NSString *air1 = HeWeatherDataService30.aqi.city.qlty;
                    NSString *air = [NSString stringWithFormat:@"空气质量 %@ %@",air1,HeWeatherDataService30.aqi.city.aqi];
                    NSString *timeStr = [HeWeatherDataService30.basic.update.loc substringToIndex:10];
                    NSString *wind = [NSString stringWithFormat:@"%@%@级",HeWeatherDataService30.now.wind.dir,HeWeatherDataService30.now.wind.sc];
                    NSString *tmp = HeWeatherDataService30.now.tmp;
                    WeatherDailyForecast *today = HeWeatherDataService30.dailyForecast.firstObject;
                    WeatherCond *tocond = today.cond;
                    
                    if (air1) {
                        view.XYAirLabel.text = air;
                        view.XYAirLabel.shadowColor = [UIColor grayColor];
                        view.XYAirLabel.shadowOffset = CGSizeMake(1, 1);
                    }
                    else{
                        view.XYAirLabel.hidden = YES;
                        view.XYAirLabel.shadowColor = [UIColor grayColor];
                        view.XYAirLabel.shadowOffset = CGSizeMake(1, 1);
                    }
                    view.XYTimeLabel.text = timeStr;
                    view.XYWindLabel.text = wind;
                    view.XYCurrentTmp.text = [tmp stringByAppendingString:@"℃"];
                    
                    
                    
                    view.XYTimeLabel.shadowColor = [UIColor grayColor];
                    view.XYTimeLabel.shadowOffset = CGSizeMake(1, 1);
                    view.XYWindLabel.shadowColor = [UIColor grayColor];
                    view.XYWindLabel.shadowOffset = CGSizeMake(1, 1);
                    view.XYCurrentTmp.shadowColor = [UIColor grayColor];
                    view.XYCurrentTmp.shadowOffset = CGSizeMake(1, 1);
                    view.XYWeatherCondLabel.shadowColor = [UIColor grayColor];
                    view.XYWeatherCondLabel.shadowOffset = CGSizeMake(1, 1);
                    //                        NSLog(@"%@",cond);
                    NSString *backCode = tocond.codeD;
                    NSString *cond = tocond.txtD;
                    NSString *backDate = HeWeatherDataService30.basic.update.loc;
                    
                    NSString *subDate = [backDate substringWithRange:NSMakeRange(11, 2)];
                    NSInteger intSubDate = [subDate integerValue];
                    if (intSubDate > 6 && intSubDate < 18) {
                        //                                backCode = tocond.codeD;
                        
                    }
                    else{
                        backCode = tocond.codeN;
                        cond = tocond.txtN;
                    }
                    
                    view.XYWeatherCondLabel.text = cond;
                    if (currentCityIndex + 10 == tag) {
                        
                        
                        //                            if (![backCode isEqualToString:@"100"]) {
                        _sunnyDayImag.hidden = YES;
                        //                            }
                        
                        [self makeBackgroundAnimationsWithCode:backCode date:backDate];
//                        [self makeBackgroundAnimationsWithCode:@"400" date:@"2015-07-15 10:43"];
                        NSString *wind1 = HeWeatherDataService30.now.wind.dir;
                        NSMutableString *wind2 = [NSMutableString stringWithString:HeWeatherDataService30.now.wind.sc];
                        if ([self IsChinese:model.city]) {
                            if ([[tmp substringToIndex:0] isEqualToString:@"-"]) {
                                tmp = [@"负" stringByAppendingString:tmp];
                            }
                            for (int i = 0; i < wind2.length; i++) {
                                if ([[wind2 substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"-"]) {
                                    [wind2 replaceCharactersInRange:NSMakeRange(i, 1) withString:@"到"];
                                }
                            }
                            NSString *voicestr = [NSString stringWithFormat:@"今天%@的天气%@,%@%@级,温度%@摄氏度! 云之天气祝您生活愉快 !",model.city,cond,wind1,wind2,tmp];
                            _voiceStr = [NSMutableString stringWithString:voicestr];
                        }
                        else{
                            
                            if ([[tmp substringToIndex:0] isEqualToString:@"-"]) {
                                tmp = [self changeToEnglish:[tmp substringFromIndex:1]];
                                tmp = [@"negative " stringByAppendingString:tmp];
                            }
                            else{
                                tmp = [self changeToEnglish:tmp];
                            }
                            NSString *voicestr = [NSString stringWithFormat:@"The weather is %@ today in %@ at %@ degrees Celsius!    !",cond,model.city,tmp];
                            _voiceStr = [NSMutableString stringWithString:voicestr];
                        }
                        [self.XYcollection reloadData];
                        [_XYCity setTitle:model.city forState:UIControlStateNormal ] ;
                        
                    }
                }
                
            });
        }
    } error:^(NSError *error) {
        //        NSLog(@"error____%@",[error description]);
    }];
    
}
-(NSString *)changeToEnglish:(NSString *)num{
    NSInteger index = [num integerValue];
    NSArray *arr = @[@"one",@"tow",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",@"eleven",@"twelve",@"thirteen",@"fourteen",@"fifteen",@"sixteen",@"seventeen",@"eighteen",@"nineteen",@"twenty",@"twenty-one",@"twenty- two ",@"wenty- three",@"twenty- four",@"twenty- five ",@"twenty- six",@"twenty- seven ",@"twenty- eight ",@"twenty- nine",@"thirty",@"thirty- one",@"thirty- two ",@"thirty- three",@"thirty- four",@"thirty- five",@"thirty- six",@"thirty- seven",@"thirty- eight",@"thirty- nine",@" forty",@"forty- one",@"forty- two ",@"forty- three",@"forty- four",@"forty- five ",@"forty- six ",@"forty- seven"];
    if (arr.count > index) {
        return arr[index - 1];
    }
    else{
        return @"high";
    }
}
//判断是否中文
-(BOOL)IsChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
    
}
#pragma -mark 背景动画
-(void)makeBackgroundAnimationsWithCode:(NSString *)code date:(NSString *)date{
    NSArray *codeArr = @[@"300",@"309",@"305",@"304",@"302",@"303",@"301",@"306",@"307",@"308",@"310",@"311",@"312",@"313",@"404",@"405",@"406",@"401",@"402",@"403",@"400",@"407"];
    //    code = @"300";
    NSArray *codeCloundArr = @[@"102",@"103"];
    NSArray *moreCodeCloundArr = @[@"101",@"104"];
    NSArray *windyArr = @[@"200",@"201",@"202",@"203",@"204"];
    NSArray *bgWindyArr = @[@"205",@"206",@"207",@"208",@"209",@"210",@"211",@"212",@"213"];
    NSArray *fogArr = @[@"500",@"501",@"502"];
    NSArray *stormArr = @[@"503",@"504",@"505",@"506",@"507",@"508"];
    if ([codeArr containsObject:code]) {
        [self rianOrSnowWithCode:code date:date];
        return;
    }
    else{
        //        for (UIImageView *view in _imagesArray) {
        //            view.hidden = YES;
        //        }
        _imagesArray = nil;
    }
    if ([code isEqualToString:@"100"]) {
        [self sunnyDayWithDate:date];
        //        return;
    }
    if ([codeCloundArr containsObject:code]) {
        [self MorecloundWithDate:date];
        //        return;
    }
    if ([moreCodeCloundArr containsObject:code]) {
        [self bgMorecloundWithDate:date];
        //        return;
    }
    if ([windyArr containsObject:code]) {
        [self windyWithDate:date];
        //        return;
    }
    if ([bgWindyArr containsObject:code]) {
        [self bgWindyWithDate:date];
        //        return;
    }
    if ([fogArr containsObject:code]) {
        [self fogWithDate:date];
        //        return;
    }
    if ([stormArr containsObject:code]) {
        [self stormWithDate:date];
        //        return;
    }
    if ([code isEqualToString:@"900"]) {
        [self hotWithDate:date];
        //        return;
    }
    if ([code isEqualToString:@"901"]) {
        [self coldWithDate:date];
    }
    //    [self rianOrSnowWithCode:code date:date];
}

-(void)bgMorecloundWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"fog_day.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"cloudy_n_portrait.jpg"];
    }
}

-(void)coldWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_sunny.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"fog_night.jpg"];
    }
}
-(void)hotWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"sunny.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_night_sunny.jpg"];
    }
}
//沙尘暴
-(void)stormWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"haze.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_thunder_storm.jpg"];
    }
}
//雾
-(void)fogWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_middle_rain.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_night_fog.jpg"];
    }
}
//强风
-(void)bgWindyWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"cloud.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"nightcloud.jpg"];
    }
}
//微风 ---------------------------???????
-(void)windyWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"cloud.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"nightcloud.jpg"];
    }
}
//多云
-(void)MorecloundWithDate:(NSString *)date{
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"cloud.jpg"];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"nightcloud.jpg"];
    }
}

//晴
-(void)sunnyDayWithDate:(NSString *)date{
    
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:@"sunny.jpg"];
        //        static dispatch_once_t onceToken;
        //        dispatch_once(&onceToken, ^{
        _sunnyDayImag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width + 100, Main_Screen_Width + 100)];
        _sunnyDayImag.center = CGPointMake(SCREEN_width*0.91, SCREENH_height*0.56);
        _sunnyDayImag.image = [UIImage imageNamed:@"ele_sunnySunshine"];
        [_XYFrontImageView addSubview:_sunnyDayImag];
        //        });
        //        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(makeSunshine) userInfo:nil repeats:YES];
        [self makeSunshine];
        
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:@"bg_night_sunny.jpg"];
    }
    
}
-(void)makeSunshine{
    if (_sunnyDayImag.hidden) {
        _sunnyDayImag.hidden = NO;
    }
    
    //    [UIView animateWithDuration:5 delay:0 options:0  animations:^
    //     {
    //         //顺时针旋转0.05 = 0.05 * 180 = 9°
    //         _sunnyDayImag.transform=CGAffineTransformMakeRotation(-0.7);
    //     } completion:^(BOOL finished)
    //     {
    //         //  重复                                  反向            动画时接收交互
    //         /**
    //          UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
    //          UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
    //          UIViewAnimationOptionRepeat                    //动画重复执行
    //          UIViewAnimationOptionAutoreverse               //来回运行动画
    //          UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
    //          UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
    //          UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
    //          UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
    //          UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
    //          */
    //         [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
    //          {
    //              _sunnyDayImag.transform=CGAffineTransformMakeRotation(0.7);
    //          } completion:^(BOOL finished) {}];
    //     }];
    
    
    CGAffineTransform transform;
    
    transform = CGAffineTransformRotate(_sunnyDayImag.transform, M_E);
    //缩放
    //    transform = CGAffineTransformScale(_View_0.transform, 2, 1);
    
    //    CATransaction
    //    CATransform3D
    
    [UIView beginAnimations:@"000" context:nil];
    [UIView setAnimationDuration:20];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:10000];
    [_sunnyDayImag setTransform:transform];
    
    //开始动画
    [UIView commitAnimations];
}
//雨雪
-(void)rianOrSnowWithCode:(NSString *)code date:(NSString *)date{
    NSArray *codeArr = @[@[@"300",@"309",@"305"],@[@"304",],@[@"302",@"303",@"301",@"306",@"307",@"308",@"310",@"311",@"312"],@[@"313",@"404",@"405",@"406"],@[@"401",@"402",@"403"],@[@"400",@"407"]];
    NSInteger index = 0;
    for (int i = 0; i < codeArr.count; i ++) {
        if ([codeArr[i] containsObject:code]) {
            index = i;
            break;
        }
    }
    NSArray *backImageArr_D = @[@"bg_slight_rain_day.jpg",@"blur_bg_shower_rain_day.jpg",@"blur_bg_shower_rain_day.jpg",@"blur_bg_slight_rain_night.jpg",@"blur_bg_snow_day.jpg",@"bg_snow_day.jpg"];
    NSArray *backImageArr_N = @[@"rain_night.jpg",@"bg_thunder_storm.jpg",@"bg_thunder_storm.jpg",@"bg_heavy_rain_night.jpg",@"bg_night_snow.jpg",@"bg_night_snow.jpg"];
    NSString *subDate = [date substringWithRange:NSMakeRange(11, 2)];
    NSInteger intSubDate = [subDate integerValue];
    if (intSubDate > 6 && intSubDate < 18) {
        _XYBackgroundImgView.image = [UIImage imageNamed:backImageArr_D[index]];
    }
    else{
        _XYBackgroundImgView.image = [UIImage imageNamed:backImageArr_N[index]];
    }
    NSString *LimageName = @"snow1";
    NSArray *LimgArr = @[@"rainLine3",@"snow1"];
    int imgWidth_Max = 20;
    int imgWidth_Min = 10;
    switch (index) {
        case 0:
            LimageName = @"rainLine3";
            imgWidth_Max = 25;
            imgWidth_Min = 15;
            break;
            
        case 1:
            LimageName = @"rainLine3";
            imgWidth_Max = 20;
            imgWidth_Min = 10;
            break;
            
        case 2:
            LimageName = @"rainLine3";
            imgWidth_Max = 30;
            imgWidth_Min = 20;
            break;
            
        case 3:
            LimageName = @"snow1";
            imgWidth_Max = 20;
            imgWidth_Min = 10;
            break;
            
        case 4:
            LimageName = @"snow1";
            imgWidth_Max = 20;
            imgWidth_Min = 10;
            break;
            
        case 6:
            LimageName = @"snow1";
            imgWidth_Max = 20;
            imgWidth_Min = 10;
            break;
            
        default:
            break;
    }
    _imagesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 180; ++ i) {
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(SNOW_IMAGENAME)];
        UIImageView *imageView = [[UIImageView alloc] init];
        int a = arc4random()%(4-0+1)+ 0;
        if (index == 1 || index == 3) {
            if (a != 0) {
                imageView.image = [UIImage imageNamed:LimgArr.firstObject];
            }
            else{
                imageView.image = [UIImage imageNamed:LimgArr.lastObject];
            }
        }
        else{
            imageView.image = [UIImage imageNamed:LimageName];
        }
        
        float x = arc4random()%imgWidth_Max + imgWidth_Min;
        if (index == 0 || index == 2) {
            //            int b = arc4random()%(5-0+1)+ 0;
            //            if (b != 0) {
            imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width ) , -130, x*1.3, x*3);
            imageView.tag = - 10 + (-i);
            //            }
            //            else{
            //                imageView.frame = CGRectMake(-60, arc4random()%((int)Main_Screen_Height + 100 +1) -100, x*1.5, x*3);
            //            }
        }
        else if (index == 1 || index == 3){
            if (a != 0) {
                imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width), -120, x*1.5, x*4);
                imageView.tag = -10 - i;
            }
            else{
                imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
            }
        }
        else{
            //            if (index == 4) {
            //                imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
            //            }
            //            else{
            imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
            //            }
        }
        _index_Code = index;
        _imgWidth_Max = imgWidth_Max;
        _imgWidth_Min = imgWidth_Min;
        imageView.alpha = IMAGE_ALPHA;
        [_XYFrontImageView addSubview:imageView];
        [_imagesArray addObject:imageView];
    }
    //    if (_timer) {
    //        [_timer invalidate];
    //    }
    float time = 0.3;
    if (index == 0) {
        time = 0.15;
    }
    if (index == 1) {
        time = 0.1;
    }
    if (index == 2) {
        time = 0.1;
    }
    if (index == 3) {
        time = 0.15;
    }
    if (index == 4 ) {
        //------------------------------?????
        time = 0.1;
    }
    if (index == 5) {
        time = 0.5;
    }
    [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    
    
}
static int i = 0;
- (void)makeSnow
{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        
        if (imageView.tag < 0) {
            
        }
        else{
            imageView.tag = i;
        }
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
    
}

- (void)snowFall:(UIImageView *)aImageView
{
    float time = 5;
    if (_index_Code == 0) {
        time = 5;
    }
    if (_index_Code == 2) {
        time = 2.5;
    }
    if (_index_Code == 3) {
        time = 3;
    }
    if (_index_Code == 4 ) {
        //------------------------------?????
        time = 4;
    }
    if (_index_Code == 5) {
        time = 10;
    }
    [UIView beginAnimations:[NSString stringWithFormat:@"%ld",aImageView.tag] context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelegate:self];
    if (_index_Code == 0 || _index_Code == 2) {
        if (aImageView.tag < 0) {
            aImageView.frame = CGRectMake(aImageView.frame.origin.x , Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
        }
        else{
            aImageView.frame = CGRectMake((((Main_Screen_Height + 100 - aImageView.frame.origin.y) * 200 )/Main_Screen_Height) - 60, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
        }
    }
    else{
        //        if (aImageView) {
        aImageView.frame = CGRectMake(aImageView.frame.origin.x , Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
        //        }
        //        else{
        //            aImageView.frame = CGRectMake(aImageView.frame.origin.x, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
        //        }
    }
    //    NSLog(@"%@",aImageView);
    [UIView commitAnimations];
}

- (void)addImage
{
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"000"]) {
        
    }
    else{
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
        //    float x = IMAGE_WIDTH;
        float x = arc4random()%_imgWidth_Max + _imgWidth_Min;
        if (_index_Code == 0 || _index_Code == 2) {
            if (imageView.tag < 0) {
                imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width), -130, x*1.3, x*3);
                
            }
            else{
                imageView.frame = CGRectMake(-60, arc4random()%((int)Main_Screen_Height + 100 +1) -100  , x*1.5, x*3);
            }
        }
        else if (_index_Code == 1 || _index_Code == 3){
            if (imageView.tag < 0) {
                imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width), -120, x*1.5, x*4);
            }
            else{
                imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
            }
            
        }
        else{
            imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
        }
        [_imagesArray addObject:imageView];
        
    }
}


#pragma mark -collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XYtodayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYcollection" forIndexPath:indexPath];
    if (_dailyForecastArr.count > 0) {
        cell.weatherDaily = (WeatherDailyForecast *)_dailyForecastArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.todayLabel.text = @"今天";
        }
        userInfoModel *model = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
        if (![self IsChinese:model.city]) {
            cell.weatherLbel.hidden = YES;
        }
        else{
            cell.weatherLbel.hidden = NO;
        }
    }
    return cell;
}

#pragma mark -scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSArray *currentCitys = [[CityDetailDBManager defaultManager]selectCityData];
    userInfoModel *model = (userInfoModel *)currentCitys.firstObject;
    NSInteger currentCityIndex = [model.index integerValue];
    NSInteger index = scrollView.contentOffset.x/SCREEN_width;
    if (index != currentCityIndex) {
        CityInfoCityInfo *city = (CityInfoCityInfo *) _CitysDataArr[index];
        [[CityDetailDBManager defaultManager]updateDataWithNewCity:city.city newCityid:city.cityInfoIdentifier newIdenx:[NSString stringWithFormat:@"%ld",index] Cityid:model.cityInfoIdentifier];
        [self updateView:index];
    }
    
}

-(void)updateView:(NSInteger )index{
    CityInfoCityInfo *city = (CityInfoCityInfo *)_CitysDataArr[index];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self dataRequestWithCityid:city.cityInfoIdentifier tag:index+10];
    });
    
}

#pragma mark -点击事件
- (IBAction)tapAddCity:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (IBAction)tapLeftMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)tapShare:(UIButton *)sender {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_voiceStr
                                     images:_XYBackgroundImgView.image
                                        url:nil
                                      title:@"#今天的天气#"
                                       type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:{
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:{
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
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
//开始语音播放
-(void)VoiceBtn{
    if (_voiceStr) {
        _iFlySpeechSynthesizer.delegate = self;
        NSString* str = [_voiceStr copy];
        [_iFlySpeechSynthesizer startSpeaking:str];
        if (_iFlySpeechSynthesizer.isSpeaking) {
            _state = Playing;
        }
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"努力加载中..."
    //                                                        message:nil
    //                                                       delegate:nil
    //                                              cancelButtonTitle:nil
    //                                              otherButtonTitles:nil];
    //    alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    //    [alertView show];
    //                sleep(1.5);
    userInfoModel *userInfo = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
    NSInteger index = [userInfo.index integerValue];
    [self dataRequestWithCityid:userInfo.cityInfoIdentifier tag:index+10];
    for (int i = 0 ; i < _CitysDataArr.count; i ++) {
        if (i == (int)index) {
            continue;
        }
        CityInfoCityInfo *city = (CityInfoCityInfo *)_CitysDataArr[i];
        [self dataRequestWithCityid:city.cityInfoIdentifier tag:i+10];
    }
    //    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    
    /** 讯飞 */
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

-(void)dealloc{
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
