//
//  LifeViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "LifeViewController.h"
#import "LifeTableViewCell.h"
#import "NewsDetailsViewController.h"
#import "HeaderCollectionViewCell.h"
#import "ItemView.h"
#import "NetWorkRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "CityDetailDBManager.h"
#import "WeatherDataModels.h"
#import "MBProgressHUD.h"
#import "Monitor.h"


@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ItemView *itemView;
@property (nonatomic, strong) NewsBaseClass *XYBase;
@property (nonatomic, strong) NSMutableArray *muArr;
@property (nonatomic, assign) NSInteger urlIndex;
@property (nonatomic, strong) CityDetailDBManager *userCity;
@property (nonatomic, strong) userInfoModel *userModer;
@property (nonatomic, strong) WeatherBaseClass *weathBase;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) BOOL isPullUp;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableArray *lifeArr;
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lifeArr = [NSMutableArray array];
    [_lifeArr addObject:@"info_9.png"];
    [_lifeArr addObject:@"info_11.png"];
    [_lifeArr addObject:@"感冒指数.png"];
    [_lifeArr addObject:@"info_17.png"];
    [_lifeArr addObject:@"旅游.png"];
    [_lifeArr addObject:@"info_12.png"];
    
    self.urlIndex = 0;
    self.userCity = [CityDetailDBManager defaultManager];
    self.userModer = [self.userCity selectCityData].firstObject;
    self.muArr = [NSMutableArray array];
    self.navigationItem.title = @"生活";
    [self initUI];
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(TapBackAction)];
    [self requestData];
    
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    [_tableView registerNib:[UINib nibWithNibName:@"LifeTableViewCell" bundle:nil] forCellReuseIdentifier:@"lifeCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((SCREEN_width-30)/2,(180-26)/3);
    //设置每个item的间距
    flowLayout.minimumInteritemSpacing = 5;
    //设置CollectionView的item距离屏幕上左下右的间距(默认都是10)
    flowLayout.sectionInset = UIEdgeInsetsMake(10 , 10, 10, 10);
    //设置每个item的行间距(默认是10.0)
    flowLayout.minimumLineSpacing = 3;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_width, 180) collectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Headercollection"];
    _collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _tableView.tableHeaderView = _collectionView;
    [self.view addSubview:_tableView];
    
    /** 上拉加载更多 */
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.urlIndex += 20;
        self.isPullUp = YES;
        [self requestData];
    }];
    
    /** 下拉刷新 */
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进入刷新状态后会自动调用block
        self.isPullUp = NO;
        self.urlIndex = 0;
        [self.muArr removeAllObjects];
        [self requestData];
    }];
}

#pragma mark -网络请求
-(void)requestData{
    /** 监听网络 */
    [Monitor monitorWithView:self.view];
    /** utf-8编码 */
    NSString *data = [NSString stringWithFormat:@"%@",self.userModer.city];
    NSString *dataUTF8 = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/local/%@/%ld-19.html",dataUTF8,self.urlIndex] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@">>>>>>>%@",[NSString stringWithFormat:@"http://c.m.163.com/nc/article/local/%@/%ld-19.html",dataUTF8,self.urlIndex]);
        if (dic[self.userModer.city]) {
            /** 把返回的地名改为cityNew */
            NSDictionary *dic2 = [NSDictionary dictionaryWithObject:dic[self.userModer.city] forKey:@"cityNew"];
            _XYBase = [[NewsBaseClass alloc]initWithDictionary:dic2];
            //            _muArr = [NSMutableArray arrayWithArray:_XYBase.myProperty1];
            NSMutableArray *loadArr = [NSMutableArray arrayWithArray:_XYBase.myProperty1];
            /** 删除数组中的NewsInternalBaseClass1对象含有imgextra数组的对象  删除含有editor数组的对象 */
            for (int i = 0 ; i < _XYBase.myProperty1.count; i++) {
                if ([_XYBase.myProperty1[i] imgextra].count > 0 || [_XYBase.myProperty1[i] editor]) {
                    [loadArr removeObject:_XYBase.myProperty1[i]];
                }
            }
            for (id obj in loadArr) {
                [self.muArr addObject:obj];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.isPullUp == YES) {
                    [_tableView.mj_footer endRefreshing];
                }
                else{
                    [_tableView.mj_header endRefreshing];
                }
                [self.tableView reloadData];
                [self.collectionView reloadData];
                
                /** 判断有没有请求下来数据 */
                if (_XYBase.myProperty1.count == 0) {
                    [self showHUD:[NSString stringWithFormat:@"抱歉!小编没有找到%@新闻",_userModer.city]];
                }
                
            });
            
        }
    } error:^(NSError *error) {
        
    }];
    
    /** 宜忌 */
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"https://api.heweather.com/x3/weather?key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",self.userModer.cityInfoIdentifier] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _weathBase = [[WeatherBaseClass alloc]initWithDictionary:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}



#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _muArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsInternalBaseClass1 *newsModel =_muArr[indexPath.row];
    LifeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lifeCell" forIndexPath:indexPath];
    if (_muArr.count > 0) {
        cell.newsLive = newsModel;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"本地新闻";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailsViewController *newsVc = [NewsDetailsViewController new];
    newsVc.URLstr = [_muArr[indexPath.row] url];
    [self.navigationController pushViewController:newsVc animated:YES];
}

#pragma mark -collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Headercollection" forIndexPath:indexPath];
//    cell.weatherSugges = [[_weathBase heWeatherDataService30][0] suggestion];
    _arr = @[@"洗车",@"穿衣",@"感冒",@"运动",@"旅游",@"紫外线"];
    NSMutableArray *array = [NSMutableArray array];
    if ([_weathBase heWeatherDataService30].count > 0) {
        if ([[_weathBase heWeatherDataService30][0] suggestion].cw.brf) {
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].cw.brf];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].drsg.brf];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].flu.brf];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].sport.brf];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].trav.brf];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].uv.brf];
            cell.suitableText.text = array[indexPath.row];
        }
        cell.suitable.text = _arr[indexPath.row];
        cell.HeaderImage.image = [UIImage imageNamed:_lifeArr[indexPath.row]];
    }
    if (indexPath.row == 0 || indexPath.row == 3) {
        cell.backgroundColor = LRRGBColor(208, 131, 24);
    }
    else if (indexPath.row == 1 || indexPath.row == 4){
        cell.backgroundColor = LRRGBColor(21, 164, 184);
    }
    else{
        cell.backgroundColor = LRRGBColor(236, 96, 59);
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _itemView = [[NSBundle mainBundle]loadNibNamed:@"ItemView" owner:nil options:nil][0];
    /** 添加动画 */
    [self flash];
    if (indexPath.row % 2 == 0) {
        _itemView.frame = CGRectMake(10, 74, (SCREEN_width-30)/2, 200);
    }
    else{
        _itemView.frame = CGRectMake((SCREEN_width-30)/2+20, 74, (SCREEN_width-30)/2, 200);
    }
    if (indexPath.row == 0 || indexPath.row == 3) {
        _itemView.backgroundColor = LRRGBColor(208, 131, 24);
    }
    else if (indexPath.row == 1 || indexPath.row == 4){
        _itemView.backgroundColor = LRRGBColor(21, 164, 184);
    }
    else{
        _itemView.backgroundColor = LRRGBColor(236, 96, 59);
    }
    NSMutableArray *array = [NSMutableArray array];
    if ([_weathBase heWeatherDataService30].count > 0) {
        if ([[_weathBase heWeatherDataService30][0] suggestion].cw.txt) {
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].cw.txt];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].drsg.txt];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].flu.txt];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].sport.txt];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].trav.txt];
            [array addObject:[[_weathBase heWeatherDataService30][0] suggestion].uv.txt];
            _itemView.contentLabel.text = array[indexPath.row];
        }
        _itemView.typeLabel.text = _arr[indexPath.row];
        _itemView.itemImage.image = [UIImage imageNamed:_lifeArr[indexPath.row]];
    }
    [self.view addSubview:_itemView];
    /** collectionView的cell交互关闭 */
    _collectionView.allowsSelection = NO;
    _tableView.allowsSelection = NO;
}

/** scrollviewdelegate */
/** 只要视图滚动,就会检测到这个方法 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self removedFlash];
}

/** 点击view触发的方法 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /** 移除view */
    [self removedFlash];

}


#pragma mark -view动画
-(void)flash{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.duration = 0.2;
    scaleAnimation.toValue = @(1.2);
    //group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 0.2;
    groupAnimation.repeatCount = 0;
    groupAnimation.animations = @[scaleAnimation];
    //按照原路返回
    groupAnimation.autoreverses = YES;
    [_itemView.layer addAnimation:groupAnimation forKey:@"eee"];
}

-(void)removedFlash{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.duration = 1;
    scaleAnimation.toValue = @(0.1);
    [_itemView.layer addAnimation:scaleAnimation forKey:@"scale"];
}
//在动画执行结束之后 继续执行一些操作 还是通过设置代理
/** 在执行完removedFlash后的操作,删除view */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [_itemView removeFromSuperview];
    self.collectionView.allowsSelection = YES;
    self.tableView.allowsSelection = YES;
}

#pragma mark -HUD提示
-(void)showHUD:(NSString *)showHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = showHUD;
    hud.offset = CGPointMake(0.f, 50.f);
    //2秒后隐藏
    [hud hideAnimated:YES afterDelay:2.f];
}

#pragma mark -返回按钮
-(void)TapBackAction{
   [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
