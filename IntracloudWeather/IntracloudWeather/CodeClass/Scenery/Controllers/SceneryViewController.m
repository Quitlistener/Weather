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
#import "userInfoManager.h"
#import "userInfoModel.h"

@interface SceneryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray * dataSource;
@property (nonatomic , strong) EvernoteTransition * transition;
@property (nonatomic, strong) SceneryBaseClass *sceneryBase;
@property (nonatomic, strong) userInfoModel *cityModer;
@property (nonatomic, strong) NSString *dataUTF8;

@end

@implementation SceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfoManager *inmanager = [[userInfoManager defaultManager]init];
    self.cityModer = [inmanager selectData][0];
    NSString *data = [NSString stringWithFormat:@"%@",_cityModer.city];
    _dataUTF8 = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self initUI];
    [self requestDatacitySry:_dataUTF8];
}

-(void)initUI{
    EvernoteFlowLayout *layout = [[EvernoteFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"FallsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FallsCell"];
    [self.view addSubview:_collectionView];
}


#pragma mark -网络请求
-(void)requestDatacitySry:(NSString *)str{
    [NetWorkRequest requestWithMethod:GET URL:[NSString stringWithFormat:@"http://apis.baidu.com/qunartravel/travellist/travellist?query=%@&page=1",str] para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.sceneryBase = [[SceneryBaseClass alloc]initWithDictionary:dic];
        NSLog(@">>>>>>>%@",dic);
    } error:^(NSError *error) {
        
    }];
}


#pragma mark -Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count + 5;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FallsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FallsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.tag = indexPath.section;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FallsCollectionViewCell * selectedCell = (FallsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray * visibleCells = collectionView.visibleCells;
//    UIStoryboard * stb  = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SceneryDetailViewController * VC = [SceneryDetailViewController new];
    CGRect finalFrame = CGRectMake(10, collectionView.contentOffset.y + 30,  ScreenW- 20, ScreenH - 40);
    [self.transition evernoteTransitionWithSelectCell:selectedCell visibleCells:visibleCells originFrame:selectedCell.frame finalFrame:finalFrame panViewController:VC listViewController:self];
    VC.transitioningDelegate = self.transition;
    VC.delegate = self.transition;
    [self presentViewController:VC animated:YES completion:^{
        
    }];
    
}

#pragma mark - getter
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i< 20; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"Evernote%d",i]];
        }
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
