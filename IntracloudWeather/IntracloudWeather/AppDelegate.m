//
//  AppDelegate.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import "RightMenViewController.h"
#import "WeatherViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "Definition.h"
#import <CoreLocation/CoreLocation.h>
#import "CityInfoDataModels.h"
#import "CityDetailDBManager.h"
#import "userInfoModel.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "Monitor.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WeiboSDK.h"



@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationMabager;
@property(nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (strong, nonatomic) MMDrawerController *drawer;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        // 注意设置为TRUE
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        /** 定位 */
        [self getLocation];
    }
    LeftMenuViewController *left = [LeftMenuViewController new];
    WeatherViewController *weather = [WeatherViewController new];
    RightMenViewController *right = [RightMenViewController new];
    UINavigationController *rightNav = [[UINavigationController alloc]initWithRootViewController:right];
//    UINavigationController *cent = [[UINavigationController alloc]initWithRootViewController:weather];
    UINavigationController *leftNav = [[UINavigationController alloc]initWithRootViewController:left];
//    rightNav.navigationBarHidden = YES;
//    cent.navigationBarHidden = YES;
    leftNav.navigationBarHidden = YES;
    MMDrawerController *drawer = [[MMDrawerController alloc]initWithCenterViewController:weather leftDrawerViewController:leftNav rightDrawerViewController:rightNav];
    
    /** 手势 */
    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawer setMaximumRightDrawerWidth:279];
    [drawer setMaximumLeftDrawerWidth:150];
    self.window.rootViewController = drawer;
    [self.window makeKeyAndVisible];
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    /** 网络监听 */
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未识别的网络");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"不可达的网络(未连接)");
//                [self showHUD:@"网络未连接"];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi的网络");
//                break;
//            default:
//                break;
//        }
//    }];
//    [manager startMonitoring];
    /** 网络监听 */
    [Monitor monitorWithView:self.window];
    
    /** 分享 */
    [ShareSDK registerApp:@"16cf00486f91a"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
                 
             default:
                 break;
         }
     }];
    
    return YES;
}

/** 讯飞语音 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    return YES;
}


#pragma mark -定位
-(CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

/** 然后初始化变量manager */
- (void)getLocation{
    _locationMabager = [[CLLocationManager alloc]init];
    [_locationMabager requestAlwaysAuthorization];
    _locationMabager.delegate = self;
    [_locationMabager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currLocation= [locations lastObject];
    //反编码 经纬度转化为具体的地理信息  武宣23.604162 经度 = 109.662870
    CLLocationCoordinate2D coor2D = CLLocationCoordinate2DMake(currLocation.coordinate.latitude,currLocation.coordinate.longitude);
    //    CLLocationCoordinate2D coor2D = CLLocationCoordinate2DMake(39.5427,116.2317);
    [self regeocoordinate:coor2D];
    [self showHUD:@"定位成功"];
    /** 关掉定位 */
    [self.locationMabager stopUpdatingLocation];
}

//把经纬度转化为地址信息
-(void)regeocoordinate:(CLLocationCoordinate2D)cood{
    //把经纬度转化为cllocation位置信息
    CLLocation *location = [[CLLocation alloc]initWithLatitude:cood.latitude longitude:cood.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //如果有错误
        if(error){
            //打印错误
            NSLog(@"line = %d error = %@",__LINE__,error );
            //退出
            return ;
        }
        //没有错误 取出一个位置坐标
        CLPlacemark *placemark = placemarks.firstObject;
        //遍历打印"CLPlacemark"这个类中"addressDictionary"这个属性的值(一般这个字典中的信息就够用了)
        [placemark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            CLPlacemark * plmark = [placemarks objectAtIndex:0];
            //            plmark.subLocality
            NSMutableString *str = [plmark.subLocality mutableCopy];
            NSMutableString *cityStr = [plmark.locality mutableCopy];
            [str deleteCharactersInRange:NSMakeRange(0,str.length - 1)];
            [cityStr deleteCharactersInRange:NSMakeRange(cityStr.length - 1,  1)];
            NSString *filename = [[NSBundle mainBundle] pathForResource:@"allchina" ofType:@"plist"];
            NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
            CityInfoBaseClass *Models = [CityInfoBaseClass  modelObjectWithDictionary:dic];
            NSArray *arr = Models.cityInfo;
            CityDetailDBManager *manager = [CityDetailDBManager defaultManager];
            [manager createTable];
            [manager createCityTable];
            userInfoModel *model = [[userInfoModel alloc]init];
            if ([str isEqualToString:@"区"]) {
                NSLog(@"赋值city");
                for (int i = 0; i < Models.cityInfo.count; i++) {
                    CityInfoCityInfo *city = (CityInfoCityInfo *)arr[i];
                    if ([city.city isEqualToString:cityStr]) {
                        [manager insertDataModel:city];
                        [manager deleteDataWithcityid:city.cityInfoIdentifier];
                        NSInteger count = [manager selectCityData].count;
                        model.index = [NSString stringWithFormat:@"%ld",count - 1];
                        model.voiceAI = @"xiaoyan";
                        model.cityInfoIdentifier = city.cityInfoIdentifier;
                        model.city = city.city;
                        [manager insertCityDataModel:model];
                        break;
                    }
                }
            }
            else{
                NSLog(@"赋值SubLocality ---->str");
                for (int i = 0; i < Models.cityInfo.count; i++) {
                    CityInfoCityInfo *city = (CityInfoCityInfo *)arr[i];
                    if ([city.city isEqualToString:str]) {
                        [manager insertDataModel:city];
                        [manager deleteDataWithcityid:city.cityInfoIdentifier];
                        NSInteger count = [manager selectCityData].count;
                        model.index = [NSString stringWithFormat:@"%ld",count - 1];
                        model.voiceAI = @"xioayan";
                        model.cityInfoIdentifier = city.cityInfoIdentifier;
                        model.city = city.city;
                        [manager insertCityDataModel:model];
                        break;
                    }
                }
                
            }
            
        }];
        
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self showHUD:@"定位失败"];
    NSLog(@"定位失败");
}


-(void)showHUD:(NSString *)showHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = showHUD;
    hud.offset = CGPointMake(0.f, 50.f);
    //2秒后隐藏
    [hud hideAnimated:YES afterDelay:2.f];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
