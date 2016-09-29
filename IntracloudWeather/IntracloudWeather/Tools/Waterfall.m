//
//  Waterfall.m
//  UI_15自定义瀑布流
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "Waterfall.h"


//延展
@interface Waterfall ()

/** 获取item的总数 */
@property(nonatomic , assign) NSInteger numberOfItems;

/** 数组用来保存每一列的高度 */
@property (nonatomic ,strong) NSMutableArray *coulumnHeights;

/** 用来保存每个计算好的item的属性(x,y,w,h)  x轴坐标,y坐标,宽度,高度 */
@property(nonatomic , strong) NSMutableArray *itemAttributes;

/** 保存每个item的X值 */
@property (nonatomic ,assign) CGFloat detalX;

/** 保存每个item的Y值 */
@property (nonatomic ,assign) CGFloat detalY;

/** 用来记录最短的列 */
@property(nonatomic ,assign) NSInteger shortsIndex;



/** 获取最长列的索引 */
-(NSInteger)p_indexForLongColumn;


/** 获取最短列的索引 */
-(NSInteger)p_indexForShortColumn;


@end







@implementation Waterfall


//懒加载
-(NSMutableArray *)coulumnHeights{
    if (_coulumnHeights == nil) {
        _coulumnHeights = [NSMutableArray array ];
    }
    return _coulumnHeights;
}


-(NSMutableArray *)itemAttributes{
    if (_itemAttributes == nil) {
        _itemAttributes = [NSMutableArray array ];
    }
    return _itemAttributes;
}



/** 获取最长列的索引 */
-(NSInteger)p_indexForLongColumn{
    
    /** 记录哪一列最长 */
    NSInteger longIndex = 0;
    
    /** 记录当前最长高度 */
    CGFloat longsHeight = 0;
    
    for (int i = 0; i < self.numberOfcolumns; i++) {
        
        /** 获取高度 */
        CGFloat currentHeight = [self.coulumnHeights[i] floatValue];
        
        /** 判断 选出最长高度 */
        if (currentHeight > longsHeight) {
            longsHeight = currentHeight;
            longIndex = i;
        }
    }
    
    return longIndex;
}


-(NSInteger)p_indexForShortColumn{
    
    /** 记录最短索引 */
    NSInteger shortsIndex = 0;
    
    /** 记录最小值 */
    CGFloat shortsHeight = MAXFLOAT;//MAXFLOAT 最大值
    
    for (int i = 0; i < self.numberOfcolumns; i++) {
        CGFloat currentHeight = [self.coulumnHeights[i] floatValue];
        
        if (currentHeight < shortsHeight) {
            shortsHeight = currentHeight;
            shortsIndex = i;
        }
    }
    
    return shortsIndex;
}



/** 给每一列添加高度 */
-(void)addHeightWithColumns{
    for (int i = 0 ; i < self.numberOfcolumns; i++) {
        self.coulumnHeights[i] = @(self.sectionInset.top);
    }
}




/** 查找最短的列 并且设置相关属性 */
-(void)searchShortColumns{
    
    /** 获取当前最短列 */
    self.shortsIndex = [self p_indexForShortColumn];
    
    /** 接收最短列的高度 */
    CGFloat shortHeight = [self.coulumnHeights[_shortsIndex]floatValue];
    
    /** 计算X值: 内边距left + (item宽 + item间距)*索引 */
    self.detalX = self.sectionInset.left + (self.itemSize.width + self.minimumInteritemSpacing)*_shortsIndex;
    
    //计算Y值
    self.detalY = shortHeight + self.minimumInteritemSpacing;
}


/** 设置属性和fram */
-(void)setFrame:(NSIndexPath *)indexPath{
    
    /** 设置属性 */
    UICollectionViewLayoutAttributes * layoutArr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //保存item的高度
    CGFloat itemHeight = 0;
    if ([self.delegate respondsToSelector:@selector(heihForIndex:)]) {
        itemHeight = [_delegate heihForIndex:indexPath];
    }
    //设置fram
    layoutArr.frame = CGRectMake(_detalX, _detalY, self.itemSize.width, itemHeight);
    
    //放进数组
    [self.itemAttributes addObject:layoutArr];
    
    //更新高度
    _coulumnHeights[_shortsIndex] = @(_detalY + itemHeight);
    
}



-(void)prepareLayout{
    //调用父类的布局
    [super prepareLayout];
    [self addHeightWithColumns];
    
    //获取item的数量
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    
    //再为每一个item设置fram和indexPath
    for (int i = 0 ; i < self.numberOfItems; i++) {
        
        //先查找最短的列, 并设置相关属性
        [self searchShortColumns];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self setFrame:indexPath];
    }
    
}




/** 计算contentView的大小 */
-(CGSize)collectionViewContentSize{
    
    //获取最长高度的索引
    NSInteger longsIndex = [self p_indexForLongColumn];
    
    //通过索引获取高度
    CGFloat longH = [self.coulumnHeights[longsIndex] floatValue ];
    
    //获取contentSize
    CGSize contentSize = self.collectionView.frame.size;
    
    //设置最大高度+ 下
    
    contentSize.height = longH +self.sectionInset.bottom;
    
    return contentSize;
    
}



/** 返回每一个item的attribute */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.itemAttributes;
}


@end
