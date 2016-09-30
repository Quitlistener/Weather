//
//  NewsBaseClass.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsBaseClass.h"
#import "NewsInternalBaseClass1.h"


NSString *const kNewsBaseClass = @"广州";


@interface NewsBaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsBaseClass

@synthesize myProperty1 = _myProperty1;


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
    NSObject *receivedNewsInternalBaseClass1 = [dict objectForKey:kNewsBaseClass];
    NSMutableArray *parsedNewsInternalBaseClass1 = [NSMutableArray array];
    if ([receivedNewsInternalBaseClass1 isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNewsInternalBaseClass1) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNewsInternalBaseClass1 addObject:[NewsInternalBaseClass1 modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNewsInternalBaseClass1 isKindOfClass:[NSDictionary class]]) {
       [parsedNewsInternalBaseClass1 addObject:[NewsInternalBaseClass1 modelObjectWithDictionary:(NSDictionary *)receivedNewsInternalBaseClass1]];
    }

    self.myProperty1 = [NSArray arrayWithArray:parsedNewsInternalBaseClass1];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMyProperty1 = [NSMutableArray array];
    for (NSObject *subArrayObject in self.myProperty1) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMyProperty1 addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMyProperty1 addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMyProperty1] forKey:kNewsBaseClass];

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

    self.myProperty1 = [aDecoder decodeObjectForKey:kNewsBaseClass];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_myProperty1 forKey:kNewsBaseClass];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsBaseClass *copy = [[NewsBaseClass alloc] init];
    
    if (copy) {

        copy.myProperty1 = [self.myProperty1 copyWithZone:zone];
    }
    
    return copy;
}


@end
