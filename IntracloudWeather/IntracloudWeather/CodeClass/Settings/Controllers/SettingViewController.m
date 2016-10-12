//
//  SettingViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangeVoiceViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "SDImageCache.h"
#import "AboutUSViewController.h"


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backCenter)];
    [self initUI];
    
}
-(void)backCenter{
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark -init
-(void)initUI{
    _array = @[@"切换语音",@"清除缓存",@"关于"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_width, SCREENH_height)];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settingCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
    
}


#pragma mark -delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1){
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperationWithBlock:^{
            SDImageCache *cache = [SDImageCache sharedImageCache];
            float cacheSize = cache.getDiskCount;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.textLabel.text = [_array[indexPath.row] stringByAppendingFormat:@" (%.1f K)",cacheSize/1000.0];
            }];
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChangeVoiceViewController *changeVc = [ChangeVoiceViewController new];
        [self.navigationController pushViewController:changeVc animated:YES];
    }
    else if (indexPath.row == 1){
        [[SDImageCache sharedImageCache] clearDisk];
        [tableView reloadData];
    }
    else{
        AboutUSViewController *AUVC = [AboutUSViewController new];
        [self.navigationController pushViewController:AUVC animated:YES];
    }
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
