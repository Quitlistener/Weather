//
//  LifeTableViewCell.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "LifeTableViewCell.h"

@implementation LifeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setNewsLive:(NewsInternalBaseClass1 *)newsLive{
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:newsLive.imgsrc]];
    self.newsTitle.text = newsLive.title;
    self.newsText.text = newsLive.digest;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
