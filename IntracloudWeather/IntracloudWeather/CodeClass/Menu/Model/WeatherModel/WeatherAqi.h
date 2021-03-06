//
//  WeatherAqi.h
//
//  Created by   on 2016/10/8
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherCity;

@interface WeatherAqi : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) WeatherCity *city;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
