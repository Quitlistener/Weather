//
//  Waterfall.h
//  UI_15自定义瀑布流
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterFallDelegate <NSObject>

-(CGFloat)heihForIndex:(NSIndexPath *)indexPath;

@end


@interface Waterfall : UICollectionViewLayout

/** item的大小 */
@property(nonatomic ,assign) CGSize itemSize;

/** 设置内边距 */
@property(nonatomic ,assign) UIEdgeInsets sectionInset;

/** item的间距 */
@property (nonatomic , assign) CGFloat minimumInteritemSpacing;

/** 列 */
@property (nonatomic , assign)NSInteger numberOfcolumns;


/** 遵守协议  代理 */
@property(nonatomic , assign)id<WaterFallDelegate> delegate;



@end
