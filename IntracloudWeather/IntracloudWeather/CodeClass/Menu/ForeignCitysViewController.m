//
//  MoreCitysViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "ForeignCitysViewController.h"
#import "MoreCityTableViewCell.h"
#import "DetailCityInfoViewController.h"

@interface ForeignCitysViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ForeignCitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"返回";
    [self initUI];
    // Do any additional setup after loading the view.
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
    searchTextField.placeholder = @"搜索城市首字母拼音或全称🔍";
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 279, 50)];
    [headerView addSubview:searchTextField];
    XYMoretableView.tableHeaderView = headerView;
    
    [self.view addSubview:XYMoretableView];
    
}

#pragma -mark tableView协议方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        DetailCityInfoViewController *DCIVC = [DetailCityInfoViewController new];
        [self.navigationController pushViewController:DCIVC animated:YES];
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"More" forIndexPath:indexPath];
   
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
