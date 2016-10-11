//
//  SceneryBaseClass.m
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SceneryBaseClass.h"
#import "SceneryData.h"


NSString *const kSceneryBaseClassErrcode = @"errcode";
NSString *const kSceneryBaseClassData = @"data";
NSString *const kSceneryBaseClassVer = @"ver";
NSString *const kSceneryBaseClassErrmsg = @"errmsg";
NSString *const kSceneryBaseClassRet = @"ret";


@interface SceneryBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SceneryBaseClass

@synthesize errcode = _errcode;
@synthesize data = _data;
@synthesize ver = _ver;
@synthesize errmsg = _errmsg;
@synthesize ret = _ret;


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
            self.errcode = [[self objectOrNilForKey:kSceneryBaseClassErrcode fromDictionary:dict] doubleValue];
            self.data = [SceneryData modelObjectWithDictionary:[dict objectForKey:kSceneryBaseClassData]];
            self.ver = [[self objectOrNilForKey:kSceneryBaseClassVer fromDictionary:dict] doubleValue];
            self.errmsg = [self objectOrNilForKey:kSceneryBaseClassErrmsg fromDictionary:dict];
            self.ret = [[self objectOrNilForKey:kSceneryBaseClassRet fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.errcode] forKey:kSceneryBaseClassErrcode];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kSceneryBaseClassData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ver] forKey:kSceneryBaseClassVer];
    [mutableDict setValue:self.errmsg forKey:kSceneryBaseClassErrmsg];
    [mutableDict setValue:[NSNumber numberWithBool:self.ret] forKey:kSceneryBaseClassRet];

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

    self.errcode = [aDecoder decodeDoubleForKey:kSceneryBaseClassErrcode];
    self.data = [aDecoder decodeObjectForKey:kSceneryBaseClassData];
    self.ver = [aDecoder decodeDoubleForKey:kSceneryBaseClassVer];
    self.errmsg = [aDecoder decodeObjectForKey:kSceneryBaseClassErrmsg];
    self.ret = [aDecoder decodeBoolForKey:kSceneryBaseClassRet];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_errcode forKey:kSceneryBaseClassErrcode];
    [aCoder encodeObject:_data forKey:kSceneryBaseClassData];
    [aCoder encodeDouble:_ver forKey:kSceneryBaseClassVer];
    [aCoder encodeObject:_errmsg forKey:kSceneryBaseClassErrmsg];
    [aCoder encodeBool:_ret forKey:kSceneryBaseClassRet];
}

- (id)copyWithZone:(NSZone *)zone
{
    SceneryBaseClass *copy = [[SceneryBaseClass alloc] init];
    
    if (copy) {

        copy.errcode = self.errcode;
        copy.data = [self.data copyWithZone:zone];
        copy.ver = self.ver;
        copy.errmsg = [self.errmsg copyWithZone:zone];
        copy.ret = self.ret;
    }
    
    return copy;
}


@end
