//
//  SceneryDetailViewController.h
//  IntracloudWeather
//
//  Created by lanou on 2016/10/11.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeneryDetailControllerDelegate <NSObject>

- (void)detailGoBack;


@end


@interface SceneryDetailViewController : UIViewController

@property (nonatomic ,weak) id<SeneryDetailControllerDelegate>delegate;

@property (nonatomic, strong) NSString *strURL;

@end
