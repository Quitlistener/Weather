//
//  LifeTableViewCell.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LifeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsText;

@property (nonatomic, strong) NewsInternalBaseClass1 *newsLive;

@end
