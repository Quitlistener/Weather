//
//  NewsLiveInfo.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsLiveInfo.h"


NSString *const kNewsLiveInfoRoomId = @"roomId";
NSString *const kNewsLiveInfoUserCount = @"user_count";
NSString *const kNewsLiveInfoEndTime = @"end_time";
NSString *const kNewsLiveInfoPano = @"pano";
NSString *const kNewsLiveInfoStartTime = @"start_time";
NSString *const kNewsLiveInfoMutilVideo = @"mutilVideo";
NSString *const kNewsLiveInfoRemindTag = @"remindTag";
NSString *const kNewsLiveInfoType = @"type";
NSString *const kNewsLiveInfoVideo = @"video";


@interface NewsLiveInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsLiveInfo

@synthesize roomId = _roomId;
@synthesize userCount = _userCount;
@synthesize endTime = _endTime;
@synthesize pano = _pano;
@synthesize startTime = _startTime;
@synthesize mutilVideo = _mutilVideo;
@synthesize remindTag = _remindTag;
@synthesize type = _type;
@synthesize video = _video;


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
            self.roomId = [[self objectOrNilForKey:kNewsLiveInfoRoomId fromDictionary:dict] doubleValue];
            self.userCount = [[self objectOrNilForKey:kNewsLiveInfoUserCount fromDictionary:dict] doubleValue];
            self.endTime = [self objectOrNilForKey:kNewsLiveInfoEndTime fromDictionary:dict];
            self.pano = [[self objectOrNilForKey:kNewsLiveInfoPano fromDictionary:dict] boolValue];
            self.startTime = [self objectOrNilForKey:kNewsLiveInfoStartTime fromDictionary:dict];
            self.mutilVideo = [[self objectOrNilForKey:kNewsLiveInfoMutilVideo fromDictionary:dict] boolValue];
            self.remindTag = [[self objectOrNilForKey:kNewsLiveInfoRemindTag fromDictionary:dict] doubleValue];
            self.type = [[self objectOrNilForKey:kNewsLiveInfoType fromDictionary:dict] doubleValue];
            self.video = [[self objectOrNilForKey:kNewsLiveInfoVideo fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.roomId] forKey:kNewsLiveInfoRoomId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.userCount] forKey:kNewsLiveInfoUserCount];
    [mutableDict setValue:self.endTime forKey:kNewsLiveInfoEndTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.pano] forKey:kNewsLiveInfoPano];
    [mutableDict setValue:self.startTime forKey:kNewsLiveInfoStartTime];
    [mutableDict setValue:[NSNumber numberWithBool:self.mutilVideo] forKey:kNewsLiveInfoMutilVideo];
    [mutableDict setValue:[NSNumber numberWithDouble:self.remindTag] forKey:kNewsLiveInfoRemindTag];
    [mutableDict setValue:[NSNumber numberWithDouble:self.type] forKey:kNewsLiveInfoType];
    [mutableDict setValue:[NSNumber numberWithBool:self.video] forKey:kNewsLiveInfoVideo];

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

    self.roomId = [aDecoder decodeDoubleForKey:kNewsLiveInfoRoomId];
    self.userCount = [aDecoder decodeDoubleForKey:kNewsLiveInfoUserCount];
    self.endTime = [aDecoder decodeObjectForKey:kNewsLiveInfoEndTime];
    self.pano = [aDecoder decodeBoolForKey:kNewsLiveInfoPano];
    self.startTime = [aDecoder decodeObjectForKey:kNewsLiveInfoStartTime];
    self.mutilVideo = [aDecoder decodeBoolForKey:kNewsLiveInfoMutilVideo];
    self.remindTag = [aDecoder decodeDoubleForKey:kNewsLiveInfoRemindTag];
    self.type = [aDecoder decodeDoubleForKey:kNewsLiveInfoType];
    self.video = [aDecoder decodeBoolForKey:kNewsLiveInfoVideo];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_roomId forKey:kNewsLiveInfoRoomId];
    [aCoder encodeDouble:_userCount forKey:kNewsLiveInfoUserCount];
    [aCoder encodeObject:_endTime forKey:kNewsLiveInfoEndTime];
    [aCoder encodeBool:_pano forKey:kNewsLiveInfoPano];
    [aCoder encodeObject:_startTime forKey:kNewsLiveInfoStartTime];
    [aCoder encodeBool:_mutilVideo forKey:kNewsLiveInfoMutilVideo];
    [aCoder encodeDouble:_remindTag forKey:kNewsLiveInfoRemindTag];
    [aCoder encodeDouble:_type forKey:kNewsLiveInfoType];
    [aCoder encodeBool:_video forKey:kNewsLiveInfoVideo];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsLiveInfo *copy = [[NewsLiveInfo alloc] init];
    
    if (copy) {

        copy.roomId = self.roomId;
        copy.userCount = self.userCount;
        copy.endTime = [self.endTime copyWithZone:zone];
        copy.pano = self.pano;
        copy.startTime = [self.startTime copyWithZone:zone];
        copy.mutilVideo = self.mutilVideo;
        copy.remindTag = self.remindTag;
        copy.type = self.type;
        copy.video = self.video;
    }
    
    return copy;
}


@end
