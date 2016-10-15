//
//  SearchCityViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/10.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "SearchCityViewController.h"
#import "MoreCitysViewController.h"
#import "CityDetailDBManager.h"
#import "PinYin4Objc.h"

@interface SearchCityViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    BOOL _hasChoose;
}
@property(nonatomic ,strong)UITextField *searchTextField;
@property(nonatomic ,strong)NSMutableArray *searchDataArr;
@end

@implementation SearchCityViewController

-(void)viewWillDisappear:(BOOL)animated{
    [_searchTextField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
    _searchDataArr = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [self.searchTextField becomeFirstResponder];// 2
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, 28, 211, 34)];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    searchTextField.placeholder = @"搜索城市🔍";
    searchTextField.delegate = self;
    [searchTextField addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField = searchTextField;
    [self.view addSubview:_searchTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 5.0;
    button.frame = CGRectMake(226, 30, 39, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:20/255.0 green:150/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 68, 259, SCREENH_height - 68) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.layer.cornerRadius = 5.0;
    tableView.rowHeight = 35;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.hidden = YES;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView = tableView;
    [self.view addSubview:_tableView];
    
}
#pragma -mark textFiled搜索

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

-(void)textFieldEditChange:(UITextField *)textField{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        _tableView.hidden = NO;
//    });
    if (textField.text.length > 0) {
        _tableView.hidden = NO;
    }
    else{
        _tableView.hidden = YES;
    }
    NSLog(@"%@",textField.text);
    NSString *str = textField.text ;
    if (str.length > 1 &&[[str substringFromIndex:str.length - 1] isEqualToString:@" "]) {
        str = [str substringToIndex:str.length - 2] ;
    }
    [self searchCityWithSubName:str];
    [_tableView reloadData];
//    NSLog(@"*****%@",_searchDataArr);
    
}


-(void)searchCityWithSubName:(NSString *)subName{
    _searchDataArr = [NSMutableArray array];
    
    if ([self IsChinese:subName])
    {
        NSString *filename = [[NSBundle mainBundle] pathForResource:@"allchina" ofType:@"plist"];
        NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
        CityInfoBaseClass *Models = [CityInfoBaseClass  modelObjectWithDictionary:dic2];
        NSArray *arr2 = Models.cityInfo;
        for (int i = 0; i < arr2.count; i++){
            CityInfoCityInfo *city = (CityInfoCityInfo *)arr2[i];
            NSString *cityStr = city.city;
            if ([cityStr containsString:subName] || [cityStr isEqualToString:subName]){
                //____________
                [_searchDataArr addObject:city];
            }
        }
        
    }
    else{
        NSArray *arr = [self loadAllWorldCityData];
        for (int i = 0; i < arr.count; i++)
        {
            CityInfoCityInfo *city = (CityInfoCityInfo *)arr[i];
            NSString *cityStr = city.city;
            if ([self IsChinese:cityStr]){
                
                NSString *sourceText=cityStr;
                HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                NSString *pinYin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                NSString *subStr = [subName lowercaseString];
                if ([pinYin containsString:subStr] || [pinYin isEqualToString:subStr]) {
                    [_searchDataArr addObject:city];
                }
                
            }
            else{
                
                NSString *upStr = [subName capitalizedString];
                if ([cityStr containsString:upStr] || [cityStr isEqualToString:upStr]){
                    //_____________
                    [_searchDataArr addObject:city];
                }
            }
            
        }
        
    }
    
}

//判断是否中文
-(BOOL)IsChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
    
}

-(NSArray *)loadAllWorldCityData{
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"allcitys" ofType:@"plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
    CityInfoBaseClass *Models = [CityInfoBaseClass  modelObjectWithDictionary:dic2];
    NSArray *arr = Models.cityInfo;
    return arr;
    
}
-(void)cancelBtn{
    self.cancelBlock(NO);
    [self dismissViewControllerAnimated:NO completion:nil];
//    [_searchTextField resignFirstResponder];
//    [_searchTextField setText:@""];
//    _searchDataArr = nil;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.cancelBlock(NO);
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma -mark tableView协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CityInfoCityInfo *city = (CityInfoCityInfo *)_searchDataArr[indexPath.row];
    cell.textLabel.text = city.city;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityInfoCityInfo *city = _searchDataArr[indexPath.row];
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
    _hasChoose = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)dealloc{
    self.cancelBlock(_hasChoose);
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
