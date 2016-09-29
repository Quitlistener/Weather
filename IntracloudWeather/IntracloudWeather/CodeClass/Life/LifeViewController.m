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

@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ItemView *itemView;

@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    [_tableView registerNib:[UINib nibWithNibName:@"LifeTableViewCell" bundle:nil] forCellReuseIdentifier:@"lifeCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
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
}


#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lifeCell" forIndexPath:indexPath];
    cell.newsText.text = @"nb";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailsViewController *newsVc = [NewsDetailsViewController new];
    [self.navigationController pushViewController:newsVc animated:YES];
}

#pragma mark -collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Headercollection" forIndexPath:indexPath];
    cell.suitableText.text = @"hunqu";
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _itemView = [[NSBundle mainBundle]loadNibNamed:@"ItemView" owner:nil options:nil][0];
    if (indexPath.row % 2 != 0) {
        _itemView.frame = CGRectMake(10, 10, (SCREEN_width-30)/2, 200);
    }
    else{
        _itemView.frame = CGRectMake((SCREEN_width-30)/2+10, 10, (SCREEN_width-30)/2, 200);
    }
    [self.view addSubview:_itemView];
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
