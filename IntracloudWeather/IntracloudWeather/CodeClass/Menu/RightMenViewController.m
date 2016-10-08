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



@interface RightMenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    NSMutableArray *_citysDataArr;
    UICollectionView *_CityCollectionVew;
    BOOL isEdit;
    UIBarButtonItem *_editItem;
}


@end

@implementation RightMenViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    [_CityCollectionVew reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadCitys];
    [self initUI];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    
    // Do any additional setup after loading the view.
}
-(void)initUI{
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
    
//    AddCitysCollectionViewCell *cell = (AddCitysCollectionViewCell *)[sender superview];//获取cell
//    NSIndexPath *indexpath = [_CityCollectionVew indexPathForCell:cell];//获取cell对应的indexpath;
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
        
    }
    else if (_citysDataArr.count == 9){
        
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
