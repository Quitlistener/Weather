//
//  Monitor.m
//  IntracloudWeather
//
//  Created by lanou on 2016/10/14.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "Monitor.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@implementation Monitor

-(id)initWithView:(UIView *)view{
    if (self = [super init]) {
        _view = view;
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未识别的网络");
                    [self showHUD:@"未识别的网络" View:self.view];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"不可达的网络(未连接)");
                    [self showHUD:@"网络未连接" View:self.view];
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"2G,3G,4G...的网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"wifi的网络");
                    break;
                default:
                    break;
            }
        }];
        [manager startMonitoring];
    }
    return self;
}


-(void)showHUD:(NSString *)showHUD View:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view bringSubviewToFront: hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = showHUD;
    hud.offset = CGPointMake(0.f, 50.f);
    //2秒后隐藏
    [hud hideAnimated:YES afterDelay:2.f];
}

+(id)monitorWithView:(UIView *)view{
    return [[Monitor alloc]initWithView:view];
}


@end
