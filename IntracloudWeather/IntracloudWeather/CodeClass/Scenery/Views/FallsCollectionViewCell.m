//
//  FallsCollectionViewCell.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/29.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "FallsCollectionViewCell.h"

@implementation FallsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7;
    }
    return self;
}



@end
