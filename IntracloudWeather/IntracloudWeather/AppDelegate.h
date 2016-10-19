//
//  AppDelegate.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

typedef void(^reloadBlock)();
@protocol reloadData <NSObject>

-(void)reloadData;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)id <reloadData> delegate_reload;
@property(nonatomic,copy)reloadBlock reloadBlock;

@end

