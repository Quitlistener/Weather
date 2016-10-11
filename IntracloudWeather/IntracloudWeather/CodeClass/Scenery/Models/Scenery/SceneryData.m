//
//  SceneryData.m
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SceneryData.h"
#import "SceneryBooks.h"


NSString *const kSceneryDataBooks = @"books";
NSString *const kSceneryDataCount = @"count";


@interface SceneryData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SceneryData

@synthesize books = _books;
@synthesize count = _count;


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
    NSObject *receivedSceneryBooks = [dict objectForKey:kSceneryDataBooks];
    NSMutableArray *parsedSceneryBooks = [NSMutableArray array];
    if ([receivedSceneryBooks isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSceneryBooks) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSceneryBooks addObject:[SceneryBooks modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSceneryBooks isKindOfClass:[NSDictionary class]]) {
       [parsedSceneryBooks addObject:[SceneryBooks modelObjectWithDictionary:(NSDictionary *)receivedSceneryBooks]];
    }

    self.books = [NSArray arrayWithArray:parsedSceneryBooks];
            self.count = [[self objectOrNilForKey:kSceneryDataCount fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForBooks = [NSMutableArray array];
    for (NSObject *subArrayObject in self.books) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForBooks addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForBooks addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForBooks] forKey:kSceneryDataBooks];
    [mutableDict setValue:[NSNumber numberWithDouble:self.count] forKey:kSceneryDataCount];

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

    self.books = [aDecoder decodeObjectForKey:kSceneryDataBooks];
    self.count = [aDecoder decodeDoubleForKey:kSceneryDataCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_books forKey:kSceneryDataBooks];
    [aCoder encodeDouble:_count forKey:kSceneryDataCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    SceneryData *copy = [[SceneryData alloc] init];
    
    if (copy) {

        copy.books = [self.books copyWithZone:zone];
        copy.count = self.count;
    }
    
    return copy;
}


@end
