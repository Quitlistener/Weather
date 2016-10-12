//
//  CurrentWeatherDetailsView.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentWeatherDetailsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *XYCurrentTmp;
@property (weak, nonatomic) IBOutlet UILabel *XYWeatherCondLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYWindLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYAirLabel;
@property (weak, nonatomic) IBOutlet UIButton *XYVoiceBtn;


@end
