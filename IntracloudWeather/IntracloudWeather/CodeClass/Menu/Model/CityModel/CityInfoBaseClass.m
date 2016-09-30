//
//  CityInfoBaseClass.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "CityInfoBaseClass.h"
#import "CityInfoCityInfo.h"


NSString *const kCityInfoBaseClassCityInfo = @"city_info";
NSString *const kCityInfoBaseClassStatus = @"status";


@interface CityInfoBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CityInfoBaseClass

@synthesize cityInfo = _cityInfo;
@synthesize status = _status;


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
    NSObject *receivedCityInfoCityInfo = [dict objectForKey:kCityInfoBaseClassCityInfo];
    NSMutableArray *parsedCityInfoCityInfo = [NSMutableArray array];
    if ([receivedCityInfoCityInfo isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCityInfoCityInfo) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCityInfoCityInfo addObject:[CityInfoCityInfo modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCityInfoCityInfo isKindOfClass:[NSDictionary class]]) {
       [parsedCityInfoCityInfo addObject:[CityInfoCityInfo modelObjectWithDictionary:(NSDictionary *)receivedCityInfoCityInfo]];
    }

    self.cityInfo = [NSArray arrayWithArray:parsedCityInfoCityInfo];
            self.status = [self objectOrNilForKey:kCityInfoBaseClassStatus fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCityInfo = [NSMutableArray array];
    for (NSObject *subArrayObject in self.cityInfo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCityInfo addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCityInfo addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCityInfo] forKey:kCityInfoBaseClassCityInfo];
    [mutableDict setValue:self.status forKey:kCityInfoBaseClassStatus];

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

    self.cityInfo = [aDecoder decodeObjectForKey:kCityInfoBaseClassCityInfo];
    self.status = [aDecoder decodeObjectForKey:kCityInfoBaseClassStatus];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_cityInfo forKey:kCityInfoBaseClassCityInfo];
    [aCoder encodeObject:_status forKey:kCityInfoBaseClassStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    CityInfoBaseClass *copy = [[CityInfoBaseClass alloc] init];
    
    if (copy) {

        copy.cityInfo = [self.cityInfo copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
    }
    
    return copy;
}


@end
