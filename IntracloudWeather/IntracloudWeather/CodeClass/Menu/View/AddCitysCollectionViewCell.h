//
//  AddCitysCollectionViewCell.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCitysCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *XYConditionImageView;
@property (weak, nonatomic) IBOutlet UILabel *XYTopTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYDownTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYWeatherConLabel;
@property (weak, nonatomic) IBOutlet UILabel *XYCityLabel;
@property (weak, nonatomic) IBOutlet UIButton *XYDelectBtn;

@end
