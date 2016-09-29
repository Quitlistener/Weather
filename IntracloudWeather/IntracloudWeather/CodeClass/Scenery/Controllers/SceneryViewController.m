//
//  SceneryViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SceneryViewController.h"
#import "Waterfall.h"
#import "FallsCollectionViewCell.h"

@interface SceneryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFallDelegate>

@property (nonatomic, strong) Waterfall *layout;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation SceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    _layout = [[Waterfall alloc]init];
    _layout.delegate = self;//设置代理
    CGFloat width = (SCREEN_width-40)/3;
    //每个item的大小
    _layout.itemSize = CGSizeMake(width ,width);
    //设置内边距
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _layout.minimumInteritemSpacing = 10;
    //设置显示几列
    _layout.numberOfcolumns = 3;
    _collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"FallsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FallsCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark -Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FallsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FallsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

#pragma -mark  重新设置后的方法  新的高
//-(CGFloat)heihForIndex:(NSIndexPath *)indexPath{
//    
//    imageModel *model = self.muArr[indexPath.item];
//    CGFloat currentw = (SCREEN_width-40)/3;
//    CGFloat currenth = model.height/model.width*currentw;
//    return currenth;
//}




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
