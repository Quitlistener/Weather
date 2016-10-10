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
#import "userInfoManager.h"

@interface TrendViewController ()
@property (nonatomic, strong) WeatherBaseClass *weatherBase;
@property (nonatomic, strong) userInfoManager *userCity;
@property (nonatomic, strong) userInfoModel *userModer;
@property (nonatomic, strong) NSMutableArray *TemperatureMaxArr;
@property (nonatomic, strong) NSMutableArray *TemperatureMinArr;
@property (nonatomic, strong) JHLineChart *lineChart;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    self.userCity = [userInfoManager defaultManager];
    self.userModer = [self.userCity selectData][0];
    [self requestData:self.userModer.cityInfoIdentifier];
}
#pragma mark -初始化UI
-(void)initUI{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    _imageView.image = [UIImage imageNamed:@""];
    [self.view addSubview:_imageView];
    
    
}
#pragma mark -创建折线图
-(void)brokenLine{
    /** 创建表对象 */
    _lineChart = [[JHLineChart alloc]initWithFrame:CGRectMake(0, 100, SCREEN_width, SCREENH_height-100) andLineChartType:JHChartLineValueNotForEveryX];
    _lineChart.backgroundColor = [UIColor clearColor];
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    _lineChart.xLineDataArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
//    [self Temperature];
    /* 数据源 */
    _lineChart.valueArr = @[self.TemperatureMaxArr,self.TemperatureMinArr];
    /* 值折线的折线颜色 默认暗黑色*/
    _lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    /* 值点的颜色 默认橘黄色*/
    _lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* X和Y轴的颜色 默认暗黑色 */
    _lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY轴的刻度颜色 m */
    _lineChart.xAndYNumberColor = [UIColor blueColor];
    /*        设置是否填充内容 默认为否         */
    _lineChart.contentFill = NO;
    /*        设置为曲线路径         */
    _lineChart.pathCurve = NO;
    [self.imageView addSubview:_lineChart];
    /*        开始动画         */
    [_lineChart showAnimation];
    
}
/** 将气温装进数组 */
-(void)Temperature{
    for (int i = 0; i < 7; i ++) {
        WeatherDailyForecast *weatherDaily = [[_weatherBase heWeatherDataService30][0] dailyForecast][i];
        [self.TemperatureMaxArr addObject:weatherDaily.tmp.max];
        [self.TemperatureMinArr addObject:weatherDaily.tmp.min];
    }
}

#pragma mark -网络请求
-(void)requestData:(NSString *)cityStr{
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"https://api.heweather.com/x3/weather?key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",cityStr] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _weatherBase = [[WeatherBaseClass alloc]initWithDictionary:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Temperature];
            [self brokenLine];
        });
    } error:^(NSError *error) {
        
    }];
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
