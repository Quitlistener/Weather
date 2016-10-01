//
//  HotCityViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "HotCityViewController.h"
#import "MoreCitysViewController.h"
#import "CityDetailDBManager.h"

@interface HotCityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation HotCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initUI];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    // Do any additional setup after loading the view.
}
-(void)initUI{
    self.navigationItem.title = @"热门城市";
//    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadCitys)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(64, 50);
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    flowLayout.headerReferenceSize = CGSizeMake(100, 70);
    flowLayout.footerReferenceSize = CGSizeMake(100, 50);
    UICollectionView *hotCityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, 259, SCREENH_height) collectionViewLayout:flowLayout];
    hotCityCollectionVew.backgroundColor = [UIColor grayColor];
    hotCityCollectionVew.delegate = self;
    hotCityCollectionVew.dataSource = self;
    [hotCityCollectionVew registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"hotCity"];
    //注册头视图
    [hotCityCollectionVew registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"hotCity"];
    //注册尾视图
    [hotCityCollectionVew registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"hotCity"];

    
    [self.view addSubview:hotCityCollectionVew];
}

#pragma -mark collection协议方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    CityInfoCityInfo *city = _cityInfoArr[indexPath.row];
    //    [[CityDetailDBManager defaultManager] createTable];
    //    [[CityDetailDBManager defaultManager] insertDataModel:city];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//cell数目
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotCity" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 64, 50)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"城市名";
    [cell addSubview:nameLabel];
    return cell;
}

//设置多少个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


//返回头部和尾部的样式
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //需要判断返回头部视图还是尾部视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //初始化头部视图
        UICollectionReusableView *heahView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"hotCity" forIndexPath:indexPath];
        UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(4, 8, 251, 34)];
        searchTextField.backgroundColor = [UIColor whiteColor];
        searchTextField.borderStyle = UITextBorderStyleRoundedRect;
        searchTextField.clearButtonMode = UITextFieldViewModeAlways;
        searchTextField.placeholder = @"搜索城市首字母拼音或全称🔍";
        [heahView addSubview:searchTextField];
        
        UILabel *hotCityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 47, 259, 21)];
        hotCityLabel.text = @"热门城市";
        hotCityLabel.textColor = [UIColor grayColor];
        hotCityLabel.backgroundColor = [UIColor whiteColor];
        [heahView addSubview:hotCityLabel];
        
        heahView.backgroundColor = [UIColor grayColor];
        return heahView;
    }
    else{
        //初始化头部视图
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"hotCity" forIndexPath:indexPath];
        UIButton *moreCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreCityBtn.frame = CGRectMake(0, 8, 259, 34);
        moreCityBtn.backgroundColor = [UIColor whiteColor];
        [moreCityBtn setTitle:@"更多城市" forState:UIControlStateNormal];
        [moreCityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [moreCityBtn addTarget:self action:@selector(moreCity) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:moreCityBtn];
        footView.backgroundColor = [UIColor grayColor];
        return footView;
    }
    
}
#pragma -mark 更多城市
-(void)moreCity{
    MoreCitysViewController *MCVC = [MoreCitysViewController new];
    [self.navigationController pushViewController:MCVC animated:YES];
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
