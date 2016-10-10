//
//  DetailCityInfoViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "DetailCityInfoViewController.h"
#import "DetailCityTableViewCell.h"
#import "CityInfoDataModels.h"
#import "CityDetailDBManager.h"

@interface DetailCityInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_cityInfoArr;
}
@end

@implementation DetailCityInfoViewController

- (void)viewDidLoad {
    self.navigationItem.title = _cityName;
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    [self loadData];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    
//    NSString *filename=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/allchina.plist"];
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"allchina" ofType:@"plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    CityInfoBaseClass *Models = [CityInfoBaseClass  modelObjectWithDictionary:dic2];
    _cityInfoArr = [NSMutableArray array];
    NSLog(@"%@",filename);
    NSArray *arr = Models.cityInfo;
    for (CityInfoCityInfo *city in arr) {
        if ([city.prov isEqualToString:_cityName]) {
            [_cityInfoArr addObject:city];
        }
    }
    NSLog(@"1____%ld",_cityInfoArr.count);
    
}
-(void)initUI{
    
    UITableView *XYMoretableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) style:UITableViewStylePlain];
    [XYMoretableView registerNib:[UINib nibWithNibName:@"DetailCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"Detail"];
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
    
    CityInfoCityInfo *city = _cityInfoArr[indexPath.row];
    NSArray *arr = [[CityDetailDBManager defaultManager] selectData];
    if (arr.count == 9) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    for (CityInfoCityInfo *city2 in arr) {
        if ([city.city isEqualToString:city2.city]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您已添加过%@",city.city]
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
            alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [alertView show];
            //            sleep(1.5);
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            return;
        }
    }

    [[CityDetailDBManager defaultManager] createTable];
    [[CityDetailDBManager defaultManager] insertDataModel:city];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cityInfoArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail" forIndexPath:indexPath];
    CityInfoCityInfo *city = _cityInfoArr[indexPath.row];
    NSString *str = city.city;
    cell.XYCityNameLabel.text = str;
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
