//
//  SceneryBooks.m
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SceneryBooks.h"


NSString *const kSceneryBooksBookUrl = @"bookUrl";
NSString *const kSceneryBooksHeadImage = @"headImage";
NSString *const kSceneryBooksBookImgNum = @"bookImgNum";
NSString *const kSceneryBooksLikeCount = @"likeCount";
NSString *const kSceneryBooksTitle = @"title";
NSString *const kSceneryBooksUserName = @"userName";
NSString *const kSceneryBooksViewCount = @"viewCount";
NSString *const kSceneryBooksUserHeadImg = @"userHeadImg";
NSString *const kSceneryBooksCommentCount = @"commentCount";
NSString *const kSceneryBooksText = @"text";
NSString *const kSceneryBooksElite = @"elite";
NSString *const kSceneryBooksRouteDays = @"routeDays";
NSString *const kSceneryBooksStartTime = @"startTime";


@interface SceneryBooks ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SceneryBooks

@synthesize bookUrl = _bookUrl;
@synthesize headImage = _headImage;
@synthesize bookImgNum = _bookImgNum;
@synthesize likeCount = _likeCount;
@synthesize title = _title;
@synthesize userName = _userName;
@synthesize viewCount = _viewCount;
@synthesize userHeadImg = _userHeadImg;
@synthesize commentCount = _commentCount;
@synthesize text = _text;
@synthesize elite = _elite;
@synthesize routeDays = _routeDays;
@synthesize startTime = _startTime;


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
            self.bookUrl = [self objectOrNilForKey:kSceneryBooksBookUrl fromDictionary:dict];
            self.headImage = [self objectOrNilForKey:kSceneryBooksHeadImage fromDictionary:dict];
            self.bookImgNum = [[self objectOrNilForKey:kSceneryBooksBookImgNum fromDictionary:dict] doubleValue];
            self.likeCount = [[self objectOrNilForKey:kSceneryBooksLikeCount fromDictionary:dict] doubleValue];
            self.title = [self objectOrNilForKey:kSceneryBooksTitle fromDictionary:dict];
            self.userName = [self objectOrNilForKey:kSceneryBooksUserName fromDictionary:dict];
            self.viewCount = [[self objectOrNilForKey:kSceneryBooksViewCount fromDictionary:dict] doubleValue];
            self.userHeadImg = [self objectOrNilForKey:kSceneryBooksUserHeadImg fromDictionary:dict];
            self.commentCount = [[self objectOrNilForKey:kSceneryBooksCommentCount fromDictionary:dict] doubleValue];
            self.text = [self objectOrNilForKey:kSceneryBooksText fromDictionary:dict];
            self.elite = [[self objectOrNilForKey:kSceneryBooksElite fromDictionary:dict] boolValue];
            self.routeDays = [[self objectOrNilForKey:kSceneryBooksRouteDays fromDictionary:dict] doubleValue];
            self.startTime = [self objectOrNilForKey:kSceneryBooksStartTime fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.bookUrl forKey:kSceneryBooksBookUrl];
    [mutableDict setValue:self.headImage forKey:kSceneryBooksHeadImage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.bookImgNum] forKey:kSceneryBooksBookImgNum];
    [mutableDict setValue:[NSNumber numberWithDouble:self.likeCount] forKey:kSceneryBooksLikeCount];
    [mutableDict setValue:self.title forKey:kSceneryBooksTitle];
    [mutableDict setValue:self.userName forKey:kSceneryBooksUserName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.viewCount] forKey:kSceneryBooksViewCount];
    [mutableDict setValue:self.userHeadImg forKey:kSceneryBooksUserHeadImg];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentCount] forKey:kSceneryBooksCommentCount];
    [mutableDict setValue:self.text forKey:kSceneryBooksText];
    [mutableDict setValue:[NSNumber numberWithBool:self.elite] forKey:kSceneryBooksElite];
    [mutableDict setValue:[NSNumber numberWithDouble:self.routeDays] forKey:kSceneryBooksRouteDays];
    [mutableDict setValue:self.startTime forKey:kSceneryBooksStartTime];

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

    self.bookUrl = [aDecoder decodeObjectForKey:kSceneryBooksBookUrl];
    self.headImage = [aDecoder decodeObjectForKey:kSceneryBooksHeadImage];
    self.bookImgNum = [aDecoder decodeDoubleForKey:kSceneryBooksBookImgNum];
    self.likeCount = [aDecoder decodeDoubleForKey:kSceneryBooksLikeCount];
    self.title = [aDecoder decodeObjectForKey:kSceneryBooksTitle];
    self.userName = [aDecoder decodeObjectForKey:kSceneryBooksUserName];
    self.viewCount = [aDecoder decodeDoubleForKey:kSceneryBooksViewCount];
    self.userHeadImg = [aDecoder decodeObjectForKey:kSceneryBooksUserHeadImg];
    self.commentCount = [aDecoder decodeDoubleForKey:kSceneryBooksCommentCount];
    self.text = [aDecoder decodeObjectForKey:kSceneryBooksText];
    self.elite = [aDecoder decodeBoolForKey:kSceneryBooksElite];
    self.routeDays = [aDecoder decodeDoubleForKey:kSceneryBooksRouteDays];
    self.startTime = [aDecoder decodeObjectForKey:kSceneryBooksStartTime];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_bookUrl forKey:kSceneryBooksBookUrl];
    [aCoder encodeObject:_headImage forKey:kSceneryBooksHeadImage];
    [aCoder encodeDouble:_bookImgNum forKey:kSceneryBooksBookImgNum];
    [aCoder encodeDouble:_likeCount forKey:kSceneryBooksLikeCount];
    [aCoder encodeObject:_title forKey:kSceneryBooksTitle];
    [aCoder encodeObject:_userName forKey:kSceneryBooksUserName];
    [aCoder encodeDouble:_viewCount forKey:kSceneryBooksViewCount];
    [aCoder encodeObject:_userHeadImg forKey:kSceneryBooksUserHeadImg];
    [aCoder encodeDouble:_commentCount forKey:kSceneryBooksCommentCount];
    [aCoder encodeObject:_text forKey:kSceneryBooksText];
    [aCoder encodeBool:_elite forKey:kSceneryBooksElite];
    [aCoder encodeDouble:_routeDays forKey:kSceneryBooksRouteDays];
    [aCoder encodeObject:_startTime forKey:kSceneryBooksStartTime];
}

- (id)copyWithZone:(NSZone *)zone
{
    SceneryBooks *copy = [[SceneryBooks alloc] init];
    
    if (copy) {

        copy.bookUrl = [self.bookUrl copyWithZone:zone];
        copy.headImage = [self.headImage copyWithZone:zone];
        copy.bookImgNum = self.bookImgNum;
        copy.likeCount = self.likeCount;
        copy.title = [self.title copyWithZone:zone];
        copy.userName = [self.userName copyWithZone:zone];
        copy.viewCount = self.viewCount;
        copy.userHeadImg = [self.userHeadImg copyWithZone:zone];
        copy.commentCount = self.commentCount;
        copy.text = [self.text copyWithZone:zone];
        copy.elite = self.elite;
        copy.routeDays = self.routeDays;
        copy.startTime = [self.startTime copyWithZone:zone];
    }
    
    return copy;
}


@end
