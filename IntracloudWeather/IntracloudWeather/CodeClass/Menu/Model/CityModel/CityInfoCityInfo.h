//
//  CityInfoCityInfo.h
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CityInfoCityInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *cityInfoIdentifier;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *cnty;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *prov;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
