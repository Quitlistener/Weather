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

@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

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
