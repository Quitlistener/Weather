//
//  XYtodayCollectionViewCell.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "XYtodayCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

@implementation XYtodayCollectionViewCell



-(void)setWeatherDaily:(WeatherDailyForecast *)weatherDaily{
    NSString *str = [NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",weatherDaily.cond.codeD];
    [self.weatherImage sd_setImageWithURL:[NSURL URLWithString:str]];
//    self.weatherImage.tintColor = [UIColor colorWithRed:59/255 green:59/255 blue:59/255 alpha:1];
//    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc]init];
//    [downloader downloadImageWithURL:[NSURL URLWithString:str] options:SDWebImageDownloaderProgressiveDownload progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//    
//        [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        self.weatherImage.image = image;
//        self.weatherImage.tintColor = [UIColor colorWithRed:59/255 green:59/255 blue:59/255 alpha:1];
//    }];
    self.maxTemperature.text = [NSString stringWithFormat:@"%@℃",weatherDaily.tmp.max];
    self.minTemperature.text = [NSString stringWithFormat:@"%@℃",weatherDaily.tmp.min];
    self.maxTemperature.shadowColor = [UIColor whiteColor];
    self.maxTemperature.shadowOffset = CGSizeMake(0.3, 0.3);
    self.minTemperature.shadowColor = [UIColor whiteColor];
    self.minTemperature.shadowOffset = CGSizeMake(0.3, 0.3);
    if ([weatherDaily.cond.txtD isEqualToString:weatherDaily.cond.txtN]) {
        self.weatherLbel.text = weatherDaily.cond.txtD;
        self.weatherLbel.shadowColor = [UIColor whiteColor];
        self.weatherLbel.shadowOffset = CGSizeMake(0.3, 0.3);
    }
    else{
        if (weatherDaily.cond.txtD.length < 3 && weatherDaily.cond.txtN.length < 3) {
            self.weatherLbel.text = [NSString stringWithFormat:@"%@转%@",weatherDaily.cond.txtD,weatherDaily.cond.txtN];
            self.weatherLbel.shadowColor = [UIColor whiteColor];
            self.weatherLbel.shadowOffset = CGSizeMake(0.3, 0.3);
        }
        else{
            self.weatherLbel.text = [NSString stringWithFormat:@"%@",weatherDaily.cond.txtD];
            self.weatherLbel.shadowColor = [UIColor whiteColor];
            self.weatherLbel.shadowOffset = CGSizeMake(0.3, 0.3);
        }
        
    }
    /** 字符转时间 */
    NSString *string = weatherDaily.date;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";
    // NSString * -> NSDate *
    NSDate *data = [format dateFromString:string];
//    NSString *newString = [format stringFromDate:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierCoptic];
//    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    /** 时间转星期 */
//    now=data;//当前的时间
    comps = [calendar components:unitFlags fromDate:data];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
//    NSLog(@"星期:%@", [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]);
    self.todayLabel.text = [arrWeek objectAtIndex:[comps weekday] - 1];
    self.todayLabel.shadowColor = [UIColor whiteColor];
    self.todayLabel.shadowOffset = CGSizeMake(0.3, 0.3);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
