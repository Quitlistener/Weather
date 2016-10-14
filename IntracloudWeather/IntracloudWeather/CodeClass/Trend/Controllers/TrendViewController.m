//
//  TrendViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/9.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "TrendViewController.h"
#import "JHLineChart.h"
#import "WeatherDataModels.h"
#import "userInfoModel.h"
#import "CityDetailDBManager.h"
#import "UIImageView+WebCache.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "RightMenViewController.h"

@interface TrendViewController ()
@property (nonatomic, strong) WeatherBaseClass *weatherBase;
@property (nonatomic, strong) CityDetailDBManager *userCity;
@property (nonatomic, strong) userInfoModel *userModer;
@property (nonatomic, strong) NSMutableArray *TemperatureMaxArr;
@property (nonatomic, strong) NSMutableArray *TemperatureMinArr;
@property (nonatomic, strong) JHLineChart *lineChart;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray *weekArr;

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userCity = [CityDetailDBManager defaultManager];
    self.userModer = [self.userCity selectCityData].firstObject;
    [self initUIcity:_userModer.city];
    [self requestData:self.userModer.cityInfoIdentifier];
}
#pragma mark -初始化UI
-(void)initUIcity:(NSString *)cityStr{
    NSArray *imageArr = @[@"cloudy_n_portrait.jpg",@"bg_middle_rain.jpg",@"bg_thunder_storm.jpg",@"blur_bg_heavy_rain_night",@"cloudy_n_portrait.jpg",@"bg_night_sunny.jpg",@"blur_bg_shower_rain_day.jpg",@"blur_bg_slight_rain_day.jpg"];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    _imageView.image = [UIImage imageNamed:imageArr[(arc4random()%((imageArr.count-1) - 0 + 1) + 0)]];
    [self.view addSubview:_imageView];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    /** 毛玻璃 */
    _toolBar.barStyle = UIBarStyleBlack ;// 改变barStyle
    _toolBar.alpha = 0.5;
    UIButton *cityBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBnt.frame = CGRectMake(SCREEN_width/2-75, 24, 150, 30);
    [cityBnt setTitle:[NSString stringWithFormat:@"%@",cityStr] forState:UIControlStateNormal];
    [cityBnt addTarget:self action:@selector(tapCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBnt];
    /** 将button最顶层 */
    [self .view bringSubviewToFront:cityBnt];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15, 14, 50, 50);
    [leftButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [self.view bringSubviewToFront:leftButton];
    [self.imageView addSubview:_toolBar];
}
#pragma mark -创建折线图
-(void)brokenLine{
    /** 创建表对象 */
    _lineChart = [[JHLineChart alloc]initWithFrame:CGRectMake(0, SCREEN_width/2, SCREEN_width, SCREENH_height - SCREEN_width/2) andLineChartType:JHChartLineValueNotForEveryX];
    _lineChart.backgroundColor = [UIColor clearColor];
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    _lineChart.xLineDataArr = _weekArr;
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstAndFouthQuardrant;
//    [self Temperature];
    /* 数据源 */
    _lineChart.valueArr = @[self.TemperatureMaxArr,self.TemperatureMinArr];
    /* 值折线的折线颜色 默认暗黑色*/
    _lineChart.valueLineColorArr =@[ LRRGBColor(57, 95, 194), LRRGBColor(205, 205, 180)];
    /* 值点的颜色 默认橘黄色*/
    _lineChart.pointColorArr = @[LRRGBColor(120, 164, 184),[UIColor yellowColor]];
    /* X和Y轴的颜色 默认暗黑色 */
    _lineChart.xAndYLineColor = [UIColor clearColor];
    /* XY轴的刻度颜色 m */
    _lineChart.xAndYNumberColor = [UIColor blueColor];
    /*        设置是否填充内容 默认为否         */
    _lineChart.contentFill = NO;
    /*        设置为曲线路径         */
    _lineChart.pathCurve = NO;
    [self.toolBar addSubview:_lineChart];
    /*        开始动画         */
    [_lineChart showAnimation];
}

-(void)weekDateAndWind{
    /** 字符转时间 */
    int i = 0;
    for (WeatherDailyForecast *weatherDaily in [[_weatherBase heWeatherDataService30][0] dailyForecast]) {
        NSString *string = weatherDaily.date;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        // 设置日期格式 为了转换成功
        format.dateFormat = @"yyyy-MM-dd";
        // NSString * -> NSDate *
        NSDate *data = [format dateFromString:string];
        //    NSString *newString = [format stringFromDate:data];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierCoptic];
        //    NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        /** 时间转星期 */
        comps = [calendar components:unitFlags fromDate:data];
        NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
        //    NSLog(@"星期:%@", [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]);
        [self.weekArr addObject:[arrWeek objectAtIndex:[comps weekday] - 1]];
        self.weekArr[0] = @"今天";
        /** 日期 */
        NSMutableString *str = [weatherDaily.date mutableCopy];
        /** 删除某段字符 */
        [str deleteCharactersInRange:NSMakeRange(0, 5)];
        /** 替换字符 */
        [str replaceCharactersInRange:NSMakeRange(2, 1) withString:@"."];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_width- 40) / 7 * i + 5*(i+1), 80, (SCREEN_width- 40) / 7, 50)];
        dateLabel.text = str;
        dateLabel.textColor = [UIColor whiteColor];
        [self.toolBar addSubview:dateLabel];
        /** 风速风向 */
        UILabel *windforce = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_width- 40) / 7 * i +  5*(i+1), SCREENH_height-90, (SCREEN_width- 30) / 7, 30)];
        UILabel *winddirection = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_width- 40) / 7 * i + 5*(i+1), SCREENH_height-60, (SCREEN_width- 40) / 7, 30)];
        windforce.font = [UIFont systemFontOfSize:13];
        windforce.textAlignment = NSTextAlignmentCenter;
        winddirection.font = [UIFont systemFontOfSize:14];
        winddirection.textAlignment = NSTextAlignmentCenter;
        winddirection.textColor = [UIColor whiteColor];
        windforce.textColor = [UIColor whiteColor];
        if ([weatherDaily.wind.dir isEqualToString:@"无持续风向"]) {
            windforce.text = @"微风";
        }
        else{
           windforce.text = weatherDaily.wind.dir;
        }
        if ([weatherDaily.wind.sc isEqualToString:@"微风"]) {
            winddirection.text = @"<2级";
        }
        else{
            winddirection.text = [NSString stringWithFormat:@"%@级",weatherDaily.wind.sc];
        }
        [self.toolBar addSubview:windforce];
        [self.toolBar addSubview:winddirection];
        i++;
    }
}

/** 将气温装进数组 */
-(void)Temperature{
    if ([[_weatherBase heWeatherDataService30][0] dailyForecast].count > 0) {
        for (int i = 0; i < 7; i ++) {
            WeatherDailyForecast *weatherDaily = [[_weatherBase heWeatherDataService30][0] dailyForecast][i];
            [self.TemperatureMaxArr addObject:weatherDaily.tmp.max];
            [self.TemperatureMinArr addObject:weatherDaily.tmp.min];
        }
    }
}

#pragma mark -网络请求
-(void)requestData:(NSString *)cityStr{
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"https://api.heweather.com/x3/weather?key=d24d5307be8948d4b9e8ebf043a7f62a&cityid=%@",cityStr] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _weatherBase = [[WeatherBaseClass alloc]initWithDictionary:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self weekDateAndWind];
            [self Temperature];
            [self brokenLine];
            NSLog(@">>>>>%@",_weekArr);
        });
    } error:^(NSError *error) {
        
    }];
}

-(void)tapCity{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
//    RightMenViewController *rightVc = [RightMenViewController new];
//    [self presentViewController:rightVc animated:YES completion:nil];
}

-(void)leftAition:(UIButton *)btn{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark -懒加载
-(NSMutableArray *)TemperatureMaxArr{
    if (_TemperatureMaxArr == nil) {
        _TemperatureMaxArr = [NSMutableArray array];
    }
    return _TemperatureMaxArr;
}

-(NSMutableArray *)TemperatureMinArr{
    if (_TemperatureMinArr == nil) {
        _TemperatureMinArr = [NSMutableArray array];
    }
    return _TemperatureMinArr;
}

-(NSMutableArray *)weekArr{
    if (_weekArr == nil) {
        _weekArr = [NSMutableArray array];
    }
    return _weekArr;
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
