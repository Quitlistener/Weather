//
//  NewsWapPortalV2.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsWapPortalV2.h"


NSString *const kNewsWapPortalV2WapUrl = @"wap_url";
NSString *const kNewsWapPortalV2WapTitle = @"wap_title";
NSString *const kNewsWapPortalV2WapImg = @"wap_img";
NSString *const kNewsWapPortalV2WapDesc = @"wap_desc";


@interface NewsWapPortalV2 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsWapPortalV2

@synthesize wapUrl = _wapUrl;
@synthesize wapTitle = _wapTitle;
@synthesize wapImg = _wapImg;
@synthesize wapDesc = _wapDesc;


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
            self.wapUrl = [self objectOrNilForKey:kNewsWapPortalV2WapUrl fromDictionary:dict];
            self.wapTitle = [self objectOrNilForKey:kNewsWapPortalV2WapTitle fromDictionary:dict];
            self.wapImg = [self objectOrNilForKey:kNewsWapPortalV2WapImg fromDictionary:dict];
            self.wapDesc = [self objectOrNilForKey:kNewsWapPortalV2WapDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.wapUrl forKey:kNewsWapPortalV2WapUrl];
    [mutableDict setValue:self.wapTitle forKey:kNewsWapPortalV2WapTitle];
    [mutableDict setValue:self.wapImg forKey:kNewsWapPortalV2WapImg];
    [mutableDict setValue:self.wapDesc forKey:kNewsWapPortalV2WapDesc];

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

    self.wapUrl = [aDecoder decodeObjectForKey:kNewsWapPortalV2WapUrl];
    self.wapTitle = [aDecoder decodeObjectForKey:kNewsWapPortalV2WapTitle];
    self.wapImg = [aDecoder decodeObjectForKey:kNewsWapPortalV2WapImg];
    self.wapDesc = [aDecoder decodeObjectForKey:kNewsWapPortalV2WapDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_wapUrl forKey:kNewsWapPortalV2WapUrl];
    [aCoder encodeObject:_wapTitle forKey:kNewsWapPortalV2WapTitle];
    [aCoder encodeObject:_wapImg forKey:kNewsWapPortalV2WapImg];
    [aCoder encodeObject:_wapDesc forKey:kNewsWapPortalV2WapDesc];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsWapPortalV2 *copy = [[NewsWapPortalV2 alloc] init];
    
    if (copy) {

        copy.wapUrl = [self.wapUrl copyWithZone:zone];
        copy.wapTitle = [self.wapTitle copyWithZone:zone];
        copy.wapImg = [self.wapImg copyWithZone:zone];
        copy.wapDesc = [self.wapDesc copyWithZone:zone];
    }
    
    return copy;
}


@end
