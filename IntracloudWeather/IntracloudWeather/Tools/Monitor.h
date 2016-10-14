//
//  Monitor.h
//  IntracloudWeather
//
//  Created by lanou on 2016/10/14.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Monitor : NSObject

@property (nonatomic, strong) NSString *HUDstr;
@property (nonatomic, strong) UIView *view;

-(id)initWithView:(UIView *)view;

+(id)monitorWithView:(UIView *)view;


@end
