//
//  CityInfoCityInfo.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "CityInfoCityInfo.h"


NSString *const kCityInfoCityInfoId = @"id";
NSString *const kCityInfoCityInfoLat = @"lat";
NSString *const kCityInfoCityInfoCnty = @"cnty";
NSString *const kCityInfoCityInfoCity = @"city";
NSString *const kCityInfoCityInfoLon = @"lon";
NSString *const kCityInfoCityInfoProv = @"prov";


@interface CityInfoCityInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CityInfoCityInfo

@synthesize cityInfoIdentifier = _cityInfoIdentifier;
@synthesize lat = _lat;
@synthesize cnty = _cnty;
@synthesize city = _city;
@synthesize lon = _lon;
@synthesize prov = _prov;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.cityInfoIdentifier = [self objectOrNilForKey:kCityInfoCityInfoId fromDictionary:dict];
            self.lat = [self objectOrNilForKey:kCityInfoCityInfoLat fromDictionary:dict];
            self.cnty = [self objectOrNilForKey:kCityInfoCityInfoCnty fromDictionary:dict];
            self.city = [self objectOrNilForKey:kCityInfoCityInfoCity fromDictionary:dict];
            self.lon = [self objectOrNilForKey:kCityInfoCityInfoLon fromDictionary:dict];
            self.prov = [self objectOrNilForKey:kCityInfoCityInfoProv fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.cityInfoIdentifier forKey:kCityInfoCityInfoId];
    [mutableDict setValue:self.lat forKey:kCityInfoCityInfoLat];
    [mutableDict setValue:self.cnty forKey:kCityInfoCityInfoCnty];
    [mutableDict setValue:self.city forKey:kCityInfoCityInfoCity];
    [mutableDict setValue:self.lon forKey:kCityInfoCityInfoLon];
    [mutableDict setValue:self.prov forKey:kCityInfoCityInfoProv];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.cityInfoIdentifier = [aDecoder decodeObjectForKey:kCityInfoCityInfoId];
    self.lat = [aDecoder decodeObjectForKey:kCityInfoCityInfoLat];
    self.cnty = [aDecoder decodeObjectForKey:kCityInfoCityInfoCnty];
    self.city = [aDecoder decodeObjectForKey:kCityInfoCityInfoCity];
    self.lon = [aDecoder decodeObjectForKey:kCityInfoCityInfoLon];
    self.prov = [aDecoder decodeObjectForKey:kCityInfoCityInfoProv];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cityInfoIdentifier forKey:kCityInfoCityInfoId];
    [aCoder encodeObject:_lat forKey:kCityInfoCityInfoLat];
    [aCoder encodeObject:_cnty forKey:kCityInfoCityInfoCnty];
    [aCoder encodeObject:_city forKey:kCityInfoCityInfoCity];
    [aCoder encodeObject:_lon forKey:kCityInfoCityInfoLon];
    [aCoder encodeObject:_prov forKey:kCityInfoCityInfoProv];
}

- (id)copyWithZone:(NSZone *)zone
{
    CityInfoCityInfo *copy = [[CityInfoCityInfo alloc] init];
    
    if (copy) {

        copy.cityInfoIdentifier = [self.cityInfoIdentifier copyWithZone:zone];
        copy.lat = [self.lat copyWithZone:zone];
        copy.cnty = [self.cnty copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.lon = [self.lon copyWithZone:zone];
        copy.prov = [self.prov copyWithZone:zone];
    }
    
    return copy;
}


@end
