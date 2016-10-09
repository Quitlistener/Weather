//
//  TrendViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/9.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "TrendViewController.h"
#import "JHLineChart.h"

@interface TrendViewController ()

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}

-(void)initUI{
    /** 创建表对象 */
    JHLineChart *lineChart = [[JHLineChart alloc]initWithFrame:CGRectMake(10, 100, SCREEN_width-20, SCREENH_height/2) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.backgroundColor = [UIColor clearColor];
    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
    lineChart.xLineDataArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@0];
    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    /* 数据源 */
    lineChart.valueArr = @[@[@"38",@"35",@"32",@37,@30,@32,@35],@[@25,@19,@22,@23]];
    /* 值折线的折线颜色 默认暗黑色*/
    lineChart.valueLineColorArr =@[ [UIColor purpleColor], [UIColor brownColor]];
    /* 值点的颜色 默认橘黄色*/
    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* X和Y轴的颜色 默认暗黑色 */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY轴的刻度颜色 m */
    lineChart.xAndYNumberColor = [UIColor blueColor];
    /*        设置是否填充内容 默认为否         */
    lineChart.contentFill = NO;
    /*        设置为曲线路径         */
    lineChart.pathCurve = NO;
    [self.view addSubview:lineChart];
    /*        开始动画         */
    [lineChart showAnimation];
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
