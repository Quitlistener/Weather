//
//  SearchCityViewController.h
//  IntracloudWeather
//
//  Created by lanou on 2016/10/10.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cancelBlock)();
@interface SearchCityViewController : UIViewController
@property(nonatomic,copy)cancelBlock cancelBlock;
@end
