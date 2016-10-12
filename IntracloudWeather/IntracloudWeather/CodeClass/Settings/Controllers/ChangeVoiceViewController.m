//
//  ChangeVoiceViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/30.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "ChangeVoiceViewController.h"
#import "TTSConfig.h"
#import "userInfoModel.h"
#import "CityDetailDBManager.h"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface ChangeVoiceViewController ()

@end

@implementation ChangeVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesInside)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    [self initView];
}
-(void)touchesInside{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self needUpdateSettings];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - 界面初始化

-(void)initView{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    self.title = @"选择语音";
    self.view.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    // 初始化发音人选择界面
    _vcnPicker.delegate = self;
    _vcnPicker.dataSource = self;
    _vcnPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _vcnPicker.textColor = [UIColor whiteColor];
    _vcnPicker.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _vcnPicker.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _vcnPicker.highlightedTextColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    _vcnPicker.interitemSpacing = 20.0;
    _vcnPicker.fisheyeFactor = 0.001;
    _vcnPicker.pickerViewStyle = AKPickerViewStyle3D;
    _vcnPicker.maskDisabled = false;
}

-(void)needUpdateVcn{
    TTSConfig *instance = [TTSConfig sharedInstance];
    //更新发音人
    [self.vcnPicker reloadData];
    int vcnIndex= 0;
    if([instance.engineType isEqualToString: [IFlySpeechConstant TYPE_LOCAL]]){
        for (int i = 0;i < self.spVcnList.count; i++) {
            if([[[self.spVcnList objectAtIndex:i] objectForKey:@"name"] isEqualToString:instance.vcnName]){
                vcnIndex=i;
                break;
            }
        }
        [_vcnPicker selectItem:vcnIndex animated:NO];
    }
    else{
        for (int i = 0;i < instance.vcnIdentiferArray.count; i++) {
            if ([[instance.vcnIdentiferArray objectAtIndex:i] isEqualToString:instance.vcnName]) {
                vcnIndex=i;
                break;
            }
        }
        [_vcnPicker selectItem:vcnIndex animated:NO];
    }
}

-(void)needUpdateSettings{
    [self needUpdateVcn];
}


#pragma mark - 发音人设置相关
#pragma mark  AKPickerViewDataSource
- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    NSUInteger count = 1;
    TTSConfig* instance = [TTSConfig sharedInstance];
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL]){
        if(self.spVcnList == nil){
            count = 1;
        }
        else{
            count = self.spVcnList.count;
        }
    }
    else{
        count = instance.vcnIdentiferArray.count;
    }
    return count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    TTSConfig* instance = [TTSConfig sharedInstance];
    NSString *title = nil;
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL]){
        if(self.spVcnList.count > 0 && self.spVcnList.count > item){
            title = [[self.spVcnList objectAtIndex:item] objectForKey:@"nickname"];
        }
    }
    else{
        
        if(instance.vcnNickNameArray.count > item){
            title = [instance.vcnNickNameArray objectAtIndex:item];
        }
    }
    return title;
}

#pragma mark   AKPickerViewDelegate
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    TTSConfig *instance = [TTSConfig sharedInstance];
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL])
    {
        if(self.spVcnList.count > 0 && self.spVcnList.count > item)
        {
            instance.vcnName = [[self.spVcnList objectAtIndex:item] objectForKey:@"name"];
            //显示从语记下载的发音人信息
            NSDictionary *info = [self.spVcnList objectAtIndex:item];
            NSString *vcnInfo= @"";
            //发音人名称
            NSString *name = [info objectForKey:@"name"];
            if(name){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n姓名：%@",name];
            }
            //别名
            NSString *nickname = [info objectForKey:@"nickname"];
            if(nickname){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n别名：%@",nickname];
            }
            //年龄
            NSString *age = [info objectForKey:@"age"];
            if(age){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n年龄：%@",age];
            }
            //性别
            NSString *sex = [info objectForKey:@"sex"];
            if(sex){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n性别：%@",sex];
            }
        }
    }
    else{
        instance.vcnName = [instance.vcnIdentiferArray objectAtIndex:item];
        userInfoModel *model = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
        NSString *str = [instance.vcnIdentiferArray objectAtIndex:item];
        [[CityDetailDBManager defaultManager]updateDataWithCityid:model.cityInfoIdentifier newVoiceAI:str];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2 && buttonIndex == 1) {
        NSString *url = [IFlySpeechUtility  componentUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
