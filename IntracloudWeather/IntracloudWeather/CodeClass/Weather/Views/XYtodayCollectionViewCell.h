//
//  XYtodayCollectionViewCell.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataModels.h"

@interface XYtodayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) WeatherDailyForecast *weatherDaily;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLbel;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperature;
@property (weak, nonatomic) IBOutlet UILabel *minTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@end
