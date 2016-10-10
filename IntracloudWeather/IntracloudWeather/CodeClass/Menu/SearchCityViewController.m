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

@interface SearchCityViewController ()<UITextFieldDelegate>
{
    UITextField *_searchTextField;
}
@property(nonatomic ,strong)NSMutableArray *searchDataArr;
@end

@implementation SearchCityViewController

-(void)viewWillDisappear:(BOOL)animated{
    [_searchTextField resignFirstResponder];
    _searchDataArr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(14, 28, 211, 34)];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    searchTextField.placeholder = @"搜索城市🔍";
    searchTextField.delegate = self;
    [searchTextField addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField = searchTextField;
    [self.view addSubview:_searchTextField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(225, 28, 40, 34);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor colorWithRed:20/255.0 green:150/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
}
#pragma -mark textFiled搜索

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(void)textFieldEditChange:(UITextField *)textField{
    
    NSLog(@"%@",textField.text);
    NSString *str = textField.text ;
    if (str.length > 1 &&[[str substringFromIndex:str.length - 1] isEqualToString:@" "]) {
        str = [str substringToIndex:str.length - 1] ;
    }
    [self searchCityWithSubName:str];
    NSLog(@"*****%@",_searchDataArr);
    
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
                if ([pinYin containsString:subName] || [pinYin isEqualToString:subName]) {
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
    
    [self dismissViewControllerAnimated:NO completion:nil];
//    [_searchTextField resignFirstResponder];
//    [_searchTextField setText:@""];
//    _searchDataArr = nil;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
