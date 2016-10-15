//
//  LeftMenuViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuTableViewCell.h"
#import "LifeViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "WeatherViewController.h"
#import "SettingViewController.h"
#import "SceneryViewController.h"
#import "TrendViewController.h"

@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    [self initUI];
    
    // Do any additional setup after loading the view.
}
//ui数据
-(void)getData{
    
    _dataArr = [NSMutableArray arrayWithObjects:@"天气",@"趋势",@"生活",@"实景",@"设置", nil];
    
}
//
-(void)initUI{
  
    UITableView *XYMenuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 150, SCREENH_height) style:UITableViewStylePlain];
    XYMenuTableView.rowHeight = 50;
    [XYMenuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"menu"];
    XYMenuTableView.delegate = self;
    XYMenuTableView.dataSource = self;
    [XYMenuTableView setSeparatorInset:UIEdgeInsetsZero];
    [XYMenuTableView setLayoutMargins:UIEdgeInsetsZero];
    XYMenuTableView.tableFooterView = [UIView new];
    
    UIView *HeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    HeaderView.backgroundColor = [UIColor cyanColor];
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 50, 50)];
    headerImage.layer.cornerRadius = CGRectGetWidth(headerImage.frame)/2.f;
    headerImage.layer.masksToBounds = YES;
    headerImage.image = [UIImage imageNamed:@"iTunesArtwork.png"];
    [HeaderView addSubview:headerImage];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 40, 100, 30)];
    headerLabel.text = @"云之天气";
    headerLabel.textColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 89, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    [HeaderView addSubview:line];
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    backgroundImage.image = [UIImage imageNamed:@"bg_night_fog.jpg"];
    [self.view addSubview:backgroundImage];
    
    [HeaderView addSubview:headerLabel];
    XYMenuTableView.tableHeaderView = HeaderView;
    XYMenuTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
//    myView.backgroundColor = [UIColor cyanColor];
    XYMenuTableView.backgroundColor = [UIColor clearColor];
    /** 回弹 */
    XYMenuTableView.bounces = NO;
    [self.view addSubview:XYMenuTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    cell.XYImageView.image = [UIImage imageNamed:_dataArr[indexPath.row]];
    cell.XYTitleLabel.text = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WeatherViewController *WVC = [WeatherViewController new];
//        UINavigationController *WNav = [[UINavigationController alloc]initWithRootViewController:WVC];
        [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 1) {
        TrendViewController *TRVC = [TrendViewController new];
//        UINavigationController *LVNav = [[UINavigationController alloc]initWithRootViewController:LVVC];
        [self.mm_drawerController setCenterViewController:TRVC withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 2) {
        LifeViewController *LVVC = [LifeViewController new];
        UINavigationController *LVNav = [[UINavigationController alloc]initWithRootViewController:LVVC];
         [self.mm_drawerController setCenterViewController:LVNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 3) {
        SceneryViewController *SCVC = [SceneryViewController new];
        UINavigationController *SCNav = [[UINavigationController alloc]initWithRootViewController:SCVC];
        [self.mm_drawerController setCenterViewController:SCNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 4) {
                SettingViewController *SEVC = [SettingViewController new];
                UINavigationController *SENav = [[UINavigationController alloc]initWithRootViewController:SEVC];
                [self.mm_drawerController setCenterViewController:SENav withCloseAnimation:YES completion:nil];
    }
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
