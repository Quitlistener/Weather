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

@interface RightMenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_citysDataArr;
    UICollectionView *_CityCollectionVew;
}
@end

@implementation RightMenViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self reloadCitys];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
   
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.navigationItem.title = @"城市管理";
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadCitys)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCitys)];
    self.navigationItem.rightBarButtonItems = @[reloadItem,editItem];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(83, 109);
    
    UICollectionView *CityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) collectionViewLayout:flowLayout];
    CityCollectionVew.backgroundColor =  [UIColor whiteColor];
    CityCollectionVew.delegate = self;
    CityCollectionVew.dataSource = self;
    [CityCollectionVew registerNib:[UINib nibWithNibName:@"AddCitysCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"City"];
    _CityCollectionVew = CityCollectionVew;
    [self.view addSubview:CityCollectionVew];
}
//管理城市 删除操作
-(void)editCitys{
    
    
    
}

//刷新管理的城市数据
-(void)reloadCitys{
    
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    [_CityCollectionVew reloadData];
    
}

#pragma -mark collection协议方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _citysDataArr.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row < _citysDataArr.count) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        cell.XYCityLabel.text = city.city;
            return cell;

    }
    else{
        
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        return cell;
        
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCityViewController *HCVC = [HotCityViewController new];
    [self.navigationController pushViewController:HCVC animated:YES];
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
