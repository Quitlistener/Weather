//
//  ToolsHelper.h
//  抽屉效果
//
//  Created by lanou on 16/9/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#ifndef ToolsHelper_h
#define ToolsHelper_h

/** 宏定义宽高 */
#define SCREEN_width   ([UIScreen mainScreen].bounds.size.width)
#define SCREENH_height ([UIScreen mainScreen].bounds.size.height)
/** 比例 */
#define Ratio (SCREEN_width / 320.0)

/** 判断字符串是否为空 */
#define IsEmptyString(str) (([str isKindOfClass:[NSNull class]] || str == nil || [str length]<=0)? YES : NO )

/** NSLog */
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

/** 自定义颜色 */
#define LRRGBColor(r, g, b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0])
#define LRRGBAColor(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a])

#endif /* ToolsHelper_h */
