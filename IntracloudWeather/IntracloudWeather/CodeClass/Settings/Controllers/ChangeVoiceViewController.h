//
//  ChangeVoiceViewController.h
//  IntracloudWeather
//
//  Created by lanou on 2016/9/30.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SAMultisectorControl.h"
#import "AKPickerView.h"
#import "iflyMSC/iflyMSC.h"

@interface ChangeVoiceViewController : UIViewController<AKPickerViewDataSource,AKPickerViewDelegate>
@property (weak, nonatomic) IBOutlet AKPickerView *vcnPicker;
/**
 *  发音人列表
 */
@property (nonatomic, strong) NSArray *spVcnList;

@end
