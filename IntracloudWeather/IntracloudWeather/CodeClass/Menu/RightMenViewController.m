//
//  RightMenViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "RightMenViewController.h"
#import "AddCitysCollectionViewCell.h"

static NSString *ident = @"hotCIty";

@interface RightMenViewController ()

@end

@implementation RightMenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(120, 120);
    
    UICollectionView *hotCityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 300, 400) collectionViewLayout:flowLayout];
    [hotCityCollectionVew registerNib:[UINib nibWithNibName:@"AddCitysCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ident];
    [self.view addSubview:hotCityCollectionVew];
    
    // Do any additional setup after loading the view.
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
