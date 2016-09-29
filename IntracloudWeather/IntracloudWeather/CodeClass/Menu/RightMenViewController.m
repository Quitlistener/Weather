//
//  RightMenViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "RightMenViewController.h"
#import "AddCitysCollectionViewCell.h"

@interface RightMenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation RightMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(90, 90);
    
    UICollectionView *hotCityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) collectionViewLayout:flowLayout];
    hotCityCollectionVew.backgroundColor =  [UIColor whiteColor];
    hotCityCollectionVew.delegate = self;
    hotCityCollectionVew.dataSource = self;
    [hotCityCollectionVew registerNib:[UINib nibWithNibName:@"AddCitysCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotCIty"];
  
    [self.view addSubview:hotCityCollectionVew];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotCIty" forIndexPath:indexPath];
    return cell;
    
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
