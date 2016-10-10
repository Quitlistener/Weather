//
//  RightMenViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "RightMenViewController.h"
#import "AddCitysCollectionViewCell.h"
#import "HotCityViewController.h"
#import "CityDetailDBManager.h"
#import "CityInfoDataModels.h"
#import "AddCollectionViewCell.h"
#import "NetWorkRequest.h"
#import "WeatherDataModels.h"
#import "UIImageView+WebCache.h"
#import "userInfoManager.h"
#import "UIViewController+MMDrawerController.h"
#import "WeatherViewController.h"

@interface RightMenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSMutableArray *_citysDataArr;
    UICollectionView *_CityCollectionVew;
    BOOL isEdit;
    UIBarButtonItem *_editItem;
    WeatherBaseClass *_BaseModels;
}


@end

@implementation RightMenViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    [_CityCollectionVew reloadData];
    for (int i = 0; i < _citysDataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CityInfoCityInfo *city = _citysDataArr[i] ;
        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:indexPath];
    }
//    [_CityCollectionVew reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
     if (isEdit == 1) {
         [self editCitys];
     }
     else{
         
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadCitys];
    [self initUI];
    for (int i = 0; i < _citysDataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CityInfoCityInfo *city = _citysDataArr[i] ;
        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:indexPath];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backWeatherController)];
    self.navigationItem.title = @"城市管理";
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadCitys)];
    _editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCitys)];
    self.navigationItem.rightBarButtonItems = @[reloadItem,_editItem];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 7.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 10);
    flowLayout.itemSize = CGSizeMake(83, 115);
    
    UICollectionView *CityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) collectionViewLayout:flowLayout];
    CityCollectionVew.backgroundColor =  [UIColor whiteColor];
    CityCollectionVew.delegate = self;
    CityCollectionVew.dataSource = self;
    [CityCollectionVew registerNib:[UINib nibWithNibName:@"AddCitysCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"City"];
    [CityCollectionVew registerNib:[UINib nibWithNibName:@"AddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Add"];
    _CityCollectionVew = CityCollectionVew;
    [self.view addSubview:CityCollectionVew];
}
-(void)backWeatherController{
     WeatherViewController *WVC = [WeatherViewController new];
     [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
}
#pragma -mark 网络请求
-(void)dataRequestWithCityid:(NSString *)cityid indexPath:(NSIndexPath *)indexPath{
    
    NSString *str = [NSString stringWithFormat:@"key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",cityid];
    NSString *urlStr = [@"https://api.heweather.com/x3/weather?" stringByAppendingString:str];
    
    [NetWorkRequest requestWithMethod:GET URL:urlStr para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dic_____%@",dic);
        if (dic[@"HeWeather data service 3.0"]) {
            _BaseModels = [WeatherBaseClass modelObjectWithDictionary:dic];
            WeatherHeWeatherDataService30 *HeWeatherDataService30 = [_BaseModels heWeatherDataService30].firstObject;
            WeatherDailyForecast *today = [HeWeatherDataService30 dailyForecast].firstObject;
            WeatherCond *cond = [today cond];
            WeatherTmp *tmp = [today tmp];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AddCitysCollectionViewCell *cell = ( AddCitysCollectionViewCell *)[_CityCollectionVew cellForItemAtIndexPath:indexPath];
                cell.XYTopTempLabel.text = [tmp.max stringByAppendingString:@"℃"];
                cell.XYDownTempLabel.text = [tmp.min stringByAppendingString:@"℃"];
                cell.XYWeatherConLabel.text = [cond txtD];
                NSString *urlStr = [NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",cond.codeD];
                [cell.XYConditionImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
                
            });
        }
    } error:^(NSError *error) {
        //        NSLog(@"error____%@",[error description]);
    }];

    
}

//管理城市 删除操作
-(void)editCitys{
    
    if (isEdit == 0) {
        
        isEdit = 1;
        _editItem.title = @"完成";
        
//        循环遍历整个CollectionView；
        for(id cell in _CityCollectionVew.visibleCells){
            
            NSIndexPath *indexPath = [_CityCollectionVew indexPathForCell:cell];
            //除最后一个cell外都显示删除按钮；
            
            if (_citysDataArr.count < 9 && indexPath.row != _citysDataArr.count){
                AddCitysCollectionViewCell *cell2  =  (AddCitysCollectionViewCell *)cell;
                cell2.XYDelectBtn.hidden = 0;
            }
            if (_citysDataArr.count == 9 && indexPath.row == 8 ) {
                AddCitysCollectionViewCell *cell2  =  (AddCitysCollectionViewCell *)cell;
                cell2.XYDelectBtn.hidden = 0;
            }
             if (indexPath.row == _citysDataArr.count){
                AddCollectionViewCell *cell2 = (AddCollectionViewCell * )cell;
                cell2.hidden = 1;
            }
           
        }
    
        
    }
    else if (isEdit == 1){
        isEdit = 0;
        _editItem.title = @"编辑";
    }
    [_CityCollectionVew reloadData];
    
}
- (void)deleteCellButtonPressed: (id)sender{
    
    UIButton *btn = (UIButton *)sender;
    //删除cell；
    CityInfoCityInfo *city = _citysDataArr[btn.tag - 10];
    [[CityDetailDBManager defaultManager] deleteDataWithcityid:city.cityInfoIdentifier];
    [_citysDataArr removeObjectAtIndex:btn.tag - 10];
    [_CityCollectionVew reloadData];
    
}

//刷新管理的城市数据
-(void)reloadCitys{
    
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    [_CityCollectionVew reloadData];
    for (int i = 0; i < _citysDataArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CityInfoCityInfo *city = _citysDataArr[i] ;
        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:indexPath];
    }
    
}

#pragma -mark collection协议方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_citysDataArr.count == 9) {
        return 9;
    }
    return _citysDataArr.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_citysDataArr.count < 9 && indexPath.item != _citysDataArr.count) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        cell.XYCityLabel.text = city.city;
        cell.XYCityLabel.layer.cornerRadius = 5;
        cell.XYCityLabel.layer.masksToBounds = YES;
        //设置删除按钮
        // 点击编辑按钮触发事件
        if(isEdit == 0){
            //正常情况下，所有删除按钮都隐藏；
            cell.XYDelectBtn.hidden = true;
        }else{
            cell.XYDelectBtn.hidden = 0;
        }
        [cell.XYDelectBtn addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.XYDelectBtn.tag = indexPath.row + 10;
        return cell;

    }
    if (_citysDataArr.count == 9 ) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        cell.XYCityLabel.text = city.city;
        
        //设置删除按钮
        // 点击编辑按钮触发事件
        if(isEdit == 0){
            //正常情况下，所有删除按钮都隐藏；
            cell.XYDelectBtn.hidden = true;
        }else{
            //可删除情况下；
            //cell数组中的最后一个是添加按钮，不能删除；
                cell.XYDelectBtn.hidden = false;
        }
        [cell.XYDelectBtn addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.XYDelectBtn.tag = indexPath.row + 10;
        return cell;
        
    }
    
    AddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Add" forIndexPath:indexPath];
    if (isEdit == 0) {
        cell.hidden = 0;
    }
    else{
        cell.hidden = 1;
    }
        return cell;


}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_citysDataArr.count < 9 && indexPath.item != _citysDataArr.count) {
        
         CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        [[userInfoManager defaultManager] createTable];
        NSArray *arr = [[userInfoManager defaultManager] selectData];
        [[userInfoManager defaultManager] deleteDataWithcityid:[arr.firstObject cityInfoIdentifier]];
        userInfoModel *model = [userInfoModel new];
        model.index = [NSString stringWithFormat:@"%ld",indexPath.row];
        model.city = city.city;
        model.cityInfoIdentifier = city.cityInfoIdentifier;
        [[userInfoManager defaultManager] insertDataModel:model];
        WeatherViewController *WVC = [WeatherViewController new];
        [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
        
    }
    else if (_citysDataArr.count == 9){
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        [[userInfoManager defaultManager] createTable];
        NSArray *arr = [[userInfoManager defaultManager] selectData];
        [[userInfoManager defaultManager] deleteDataWithcityid:[arr.firstObject cityInfoIdentifier]];
        userInfoModel *model = [userInfoModel new];
        model.index = [NSString stringWithFormat:@"%ld",indexPath.row];
        model.city = city.city;
        model.cityInfoIdentifier = city.cityInfoIdentifier;
        [[userInfoManager defaultManager] insertDataModel:model];
        WeatherViewController *WVC = [WeatherViewController new];
        [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
        
    }
    else{
        
        HotCityViewController *HCVC = [HotCityViewController new];
        [self.navigationController pushViewController:HCVC animated:YES];
        
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
