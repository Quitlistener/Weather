//
//  EvernoteFlowLayout.h
//  EvernoteAnimation
//
//  Created by WangXuesen on 16/7/14.
//  Copyright © 2016年 Jsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenW  [[UIScreen mainScreen] bounds].size.width
#define ScreenH  [[UIScreen mainScreen] bounds].size.height

#define PaddingH 10
#define PaddingV 5

#define ItemW  ScreenW - 2*PaddingH
#define ItemH  200

#define SpringFactor 10
@interface EvernoteFlowLayout : UICollectionViewFlowLayout

@end
