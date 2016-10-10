//
//  MoreCitysViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "ForeignCitysViewController.h"
#import "MoreCityTableViewCell.h"
#import "ForeignCityViewController.h"

@interface ForeignCitysViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
}
@end

@implementation ForeignCitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"国际国外";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    [self loadData];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    _dataArr = [NSMutableArray array];
    [_dataArr addObjectsFromArray:dic2[@"countrys"]];
    
}
-(void)initUI{
    
    UITableView *XYMoretableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) style:UITableViewStylePlain];
    [XYMoretableView registerNib:[UINib nibWithNibName:@"MoreCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"More"];
    XYMoretableView.rowHeight = 40;
    XYMoretableView.delegate = self;
    XYMoretableView.dataSource = self;
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, 8, 251, 34)];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    searchTextField.placeholder = @"搜索城市🔍";
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 279, 50)];
    [headerView addSubview:searchTextField];
    XYMoretableView.tableHeaderView = headerView;
    
    [self.view addSubview:XYMoretableView];
    
}

#pragma -mark tableView协议方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ForeignCityViewController *FCVC = [ForeignCityViewController new];
    NSDictionary *dic = (NSDictionary *)_dataArr[indexPath.row];
    FCVC.countryName = dic[@"english"];
    [self.navigationController pushViewController:FCVC animated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"More" forIndexPath:indexPath];
    NSDictionary *dic = (NSDictionary *)_dataArr[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@/",dic[@"english"]];
    cell.XYCityNameLabel.text = [str stringByAppendingString:dic[@"chinese"]];
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
