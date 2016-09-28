//
//  LeftMenuViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuTableViewCell.h"

@interface LeftMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    [self initUI];
    
    // Do any additional setup after loading the view.
}
//ui数据
-(void)getData{
    
    _dataArr = [NSMutableArray arrayWithObjects:@"天气",@"趋势",@"生活",@"实景",@"设置", nil];
    
}
//
-(void)initUI{
    UITableView *XYMenuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 150, SCREENH_height) style:UITableViewStylePlain];
    XYMenuTableView.rowHeight = 40;
    [XYMenuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"menu"];
    XYMenuTableView.delegate = self;
    XYMenuTableView.dataSource = self;
    XYMenuTableView.tableFooterView = [UIView new];
    [self.view addSubview:XYMenuTableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    cell.XYImageView.image = [UIImage imageNamed:_dataArr[indexPath.row]];
    cell.XYTitleLabel.text = _dataArr[indexPath.row];
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
