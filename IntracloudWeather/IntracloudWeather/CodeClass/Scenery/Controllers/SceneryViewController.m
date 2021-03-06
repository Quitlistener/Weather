//
//  SceneryViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SceneryViewController.h"
#import "FallsCollectionViewCell.h"
#import "EvernoteFlowLayout.h"
#import "EvernoteTransition.h"
#import "SceneryDetailViewController.h"
#import "DataModels.h"
#import "CityDetailDBManager.h"
#import "userInfoModel.h"
#import "UIViewController+MMDrawerController.h"
#import "Monitor.h"
#import "MBProgressHUD.h"

@interface SceneryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic , strong) EvernoteTransition * transition;
@property (nonatomic, strong) SceneryBaseClass *sceneryBase;
@property (nonatomic, strong) userInfoModel *cityModer;
@property (nonatomic, strong) NSString *dataUTF8;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isPulldown;

@end

@implementation SceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(LeftBackAction)];
    
    self.navigationItem.title = @"本地景色";
    
    self.isPulldown = YES;
    self.pageIndex = 1;
    CityDetailDBManager *inmanager = [[CityDetailDBManager defaultManager]init];
    self.cityModer = [inmanager selectCityData].firstObject;
    NSString *data = [NSString stringWithFormat:@"%@",_cityModer.city];
    _dataUTF8 = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self initUI];
    [self requestDatacitySry:_dataUTF8];
}

-(void)initUI{
    EvernoteFlowLayout *layout = [[EvernoteFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_width, SCREENH_height-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"FallsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FallsCell"];
    [self.view addSubview:_collectionView];
    
    /** 上拉加载更多 */
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex += 1;
        self.isPulldown = NO;
        [self requestDatacitySry:_dataUTF8];
    }];
    
    /** 下拉刷新 */
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进入刷新状态后会自动调用block
        _pageIndex = 1;
         self.isPulldown = YES;
        [self.dataSource removeAllObjects];
        [self requestDatacitySry:_dataUTF8];
    }];
}

#pragma mark -网络请求
-(void)requestDatacitySry:(NSString *)str{
    
    [Monitor monitorWithView:self.view];
    NSLog(@">>>>%@",str);
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"http://apis.baidu.com/qunartravel/travellist/travellist?query=%@&page=%ld",str,self.pageIndex] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.sceneryBase = [[SceneryBaseClass alloc]initWithDictionary:dic];
        for (NSDictionary *dic2 in [self.sceneryBase.data books]) {
            [self.dataSource addObject:dic2];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isPulldown == YES) {
                [_collectionView.mj_header endRefreshing];
            }
            else{
                [_collectionView.mj_footer endRefreshing];
            }
            if ([_sceneryBase.data books].count < 1) {
                [self showHUD:[NSString stringWithFormat:@"抱歉!网友还没上传%@景色",_cityModer.city]];
            }
            [self.collectionView reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}

#pragma mark -Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FallsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FallsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.dataSource.count > 0) {
        cell.titleLabel.text = [self.dataSource[indexPath.section] title];
        [cell.sceneryImage sd_setImageWithURL:[NSURL URLWithString:[self.dataSource[indexPath.section] headImage]]];
    }
    cell.tag = indexPath.section;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FallsCollectionViewCell * selectedCell = (FallsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray * visibleCells = collectionView.visibleCells;
    //    UIStoryboard * stb  = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SceneryDetailViewController * VC = [SceneryDetailViewController new];
    if (self.dataSource.count > 0) {
        VC.strURL = [self.dataSource[indexPath.section] bookUrl];
    }
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
    CGRect finalFrame = CGRectMake(10, collectionView.contentOffset.y + 30,  ScreenW- 20, ScreenH - 40);
    [self.transition evernoteTransitionWithSelectCell:selectedCell visibleCells:visibleCells originFrame:selectedCell.frame finalFrame:finalFrame panViewController:nav listViewController:self];
    nav.transitioningDelegate = self.transition;
    VC.delegate = self.transition;
    [self presentViewController:nav animated:YES completion:^{
    }];
    
}


#pragma mark -showHUD
- (void)showHUD:(NSString *)HUDstr{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view bringSubviewToFront:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = HUDstr;
    hud.offset = CGPointMake(0.f, 0.f);
    //2秒后隐藏
    [hud hideAnimated:YES afterDelay:2.f];
}

#pragma mark -返回
-(void)LeftBackAction{
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - getter
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (EvernoteTransition *)transition {
    if (!_transition) {
        _transition = [[EvernoteTransition alloc] init];
    }
    return _transition;
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
