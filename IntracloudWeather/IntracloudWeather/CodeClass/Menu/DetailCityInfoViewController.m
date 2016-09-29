//
//  DetailCityInfoViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "DetailCityInfoViewController.h"
#import "DetailCityTableViewCell.h"

@interface DetailCityInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailCityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
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
    searchTextField.placeholder = @"搜索城市首字母拼音或全称🔍";
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 279, 50)];
    [headerView addSubview:searchTextField];
    XYMoretableView.tableHeaderView = headerView;
    
    [self.view addSubview:XYMoretableView];
    
}

#pragma -mark tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail" forIndexPath:indexPath];
    
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
