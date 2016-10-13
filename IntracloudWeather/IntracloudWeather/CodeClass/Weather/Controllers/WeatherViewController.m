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

#define SNOW_IMAGENAME         @"snow"

#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25


@interface WeatherViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,IFlySpeechSynthesizerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_CitysDataArr;
    NSMutableArray *_dailyForecastArr;
    NSMutableString *_voiceStr;
    NSMutableArray *_imagesArray;
    NSInteger _index_Code;
    int _imgWidth_Max ;
    int _imgWidth_Min ;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadCitysData];
    [self initUI];
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
    
    NSString *str = [NSString stringWithFormat:@"key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",cityid];
    NSString *urlStr = [@"https://api.heweather.com/x3/weather?" stringByAppendingString:str];
    
    [NetWorkRequest requestWithMethod:GET URL:urlStr para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dic_____%@",dic);
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
                        NSString *cond = HeWeatherDataService30.now.cond.txt;
                        if (air1) {
                            view.XYAirLabel.text = air;
                        }
                        else{
                            view.XYAirLabel.hidden = YES;
                        }
                        view.XYTimeLabel.text = timeStr;
                        view.XYWindLabel.text = wind;
                        view.XYCurrentTmp.text = [tmp stringByAppendingString:@"℃"];
                        view.XYWeatherCondLabel.text = cond;
                        NSString *backCode = HeWeatherDataService30.now.cond.code;
                        NSString *backDate = HeWeatherDataService30.basic.update.loc;
                        [self makeBackgroundAnimationsWithCode:@"304" date:backDate];
                        if (currentCityIndex + 10 == tag) {
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
                                NSString *voicestr = [NSString stringWithFormat:@"今天%@天气%@,%@%@级,温度%@摄氏度!",model.city,cond,wind1,wind2,tmp];
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
                                NSString *voicestr = [NSString stringWithFormat:@"The weather is %@ today in %@ at %@ degrees Celsius! Thinks!",cond,model.city,tmp];
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
    if (arr.count < index) {
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
    if ([codeArr containsObject:code]) {
         [self rianOrSnowWithCode:code date:date];
    }
    
//    [self rianOrSnowWithCode:code date:date];
}
-(void)rianOrSnowWithCode:(NSString *)code date:(NSString *)date{
    NSArray *codeArr = @[@[@"300",@"309",@"305"],@[@"304",],@[@"302",@"303",@"301",@"306",@"307",@"308",@"310",@"311",@"312"],@[@"313",@"404",@"405",@"406"],@[@"401",@"402",@"403"],@[@"400",@"407"]];
    NSInteger index = 0;
    for (int i = 0; i < codeArr.count; i ++) {
        if ([codeArr[i] containsObject:code]) {
            index = i;
            break;
        }
    }
    NSArray *backImageArr_D = @[@"bg_slight_rain_day.jpg",@"blur_bg_shower_rain_day.jpg",@"blur_bg_shower_rain_day.jpg",@"bg_slight_rain_night.jpg",@"blur_bg_snow_day.jpg",@"bg_snow_day.jpg"];
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
            imgWidth_Max = 30;
            imgWidth_Min = 15;
            break;
            
        case 1:
            LimageName = @"rainLine3";
            imgWidth_Max = 40;
            imgWidth_Min = 20;
            break;
            
        case 2:
            LimageName = @"rainLine3";
            imgWidth_Max = 40;
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
    for (int i = 0; i < 120; ++ i) {
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(SNOW_IMAGENAME)];
        UIImageView *imageView = [[UIImageView alloc] init];
        int a = arc4random()%(1-0+1)+ 0;
        if (index == 1 || index == 3) {
            imageView.image = [UIImage imageNamed:LimgArr[a]];
        }
        else{
            imageView.image = [UIImage imageNamed:LimageName];
        }
        
        float x = arc4random()%imgWidth_Max + imgWidth_Min;
        if (index == 0 || index == 2) {
            int b = arc4random()%(4-0+1)+ 0;
            if (b != 0) {
                imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width ) , -120, x*1.5, x*3);
                imageView.tag = - 10 + (-i);
            }
            else{
                imageView.frame = CGRectMake(-60, arc4random()%((int)Main_Screen_Height + 100 +1) -100, x*1.5, x*3);
            }
        }
        else if (index == 1 || index == 3){
            int b = arc4random()%(4-0+1)+ 0;
            if (b != 0) {
                imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width), -120, x*2, x*4);
                imageView.tag = -10 - i;
            }
            else{
                imageView.frame = CGRectMake(IMAGE_X, -50, x, x);
            }
        }
        else{
            
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
        time = 0.05;
    }
    if (index == 2) {
        time = 0.01;
    }
    if (index == 4 ) {
        //------------------------------?????
    }
    if (index == 5) {
        time = 0.3;
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
    [UIView beginAnimations:[NSString stringWithFormat:@"%ld",aImageView.tag] context:nil];
    [UIView setAnimationDuration:5];
    [UIView setAnimationDelegate:self];
    if (_index_Code == 0 || _index_Code == 2) {
        if (aImageView.tag < 0) {
             aImageView.frame = CGRectMake(aImageView.frame.origin.x + 200, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
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
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
//    float x = IMAGE_WIDTH;
    float x = arc4random()%_imgWidth_Max + _imgWidth_Min;
    if (_index_Code == 0 || _index_Code == 2) {
        if (imageView.tag < 0) {
            imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width + 200 + 1) - 200, -120, x*1.5, x*3);
            
        }
        else{
            imageView.frame = CGRectMake(-60, arc4random()%((int)Main_Screen_Height + 100 +1) -100  , x*1.5, x*3);
        }
    }
    else{
        if (imageView.tag < 0) {
            imageView.frame = CGRectMake(arc4random()%((int)Main_Screen_Width), -120, x*2, x*4);
        }
        else{
            imageView.frame = CGRectMake(IMAGE_X, -100, x, x);
        }
        
    }
    [_imagesArray addObject:imageView];
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
    
    for (int i = 0 ; i < _CitysDataArr.count; i ++) {
        CityInfoCityInfo *city = (CityInfoCityInfo *)_CitysDataArr[i];
        [self dataRequestWithCityid:city.cityInfoIdentifier tag:i+10];
    }
    
    
    
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
