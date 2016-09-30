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
#import "NetWorkRequest.h"


@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ItemView *itemView;
@property (nonatomic, strong) NewsBaseClass *XYBase;
@property (nonatomic, strong) NSMutableArray *muArr;
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self requestData];
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    [_tableView registerNib:[UINib nibWithNibName:@"LifeTableViewCell" bundle:nil] forCellReuseIdentifier:@"lifeCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150;
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

#pragma mark -网络请求
-(void)requestData{
    [NetWorkRequest requestWithMethod:GET URL:@"http://c.m.163.com/nc/article/local/5bm%2F5bee/0-20.html" para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        _XYBase = [[NewsBaseClass alloc]initWithDictionary:dic];
        _muArr = [NSMutableArray arrayWithArray:_XYBase.myProperty1];
        /** 删除数组中的NewsInternalBaseClass1对象含有imgextra数组的对象 */
        for (int i = 0 ; i < _XYBase.myProperty1.count; i++) {
            if ([_XYBase.myProperty1[i] imgextra].count > 0) {
                [_muArr removeObject:_XYBase.myProperty1[i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.collectionView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _muArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsInternalBaseClass1 *newsModel =_muArr[indexPath.row];
        LifeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lifeCell" forIndexPath:indexPath];
        cell.newsLive = newsModel;
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetailsViewController *newsVc = [NewsDetailsViewController new];
    newsVc.URLstr = [_muArr[indexPath.row] url];
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
    if (indexPath.row % 2 == 0) {
        _itemView.frame = CGRectMake(10, 74, (SCREEN_width-30)/2, 200);
    }
    else{
        _itemView.frame = CGRectMake((SCREEN_width-30)/2+20, 74, (SCREEN_width-30)/2, 200);
    }
    [self.view addSubview:_itemView];
    
}

/** 点击view触发的方法 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了view");
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
