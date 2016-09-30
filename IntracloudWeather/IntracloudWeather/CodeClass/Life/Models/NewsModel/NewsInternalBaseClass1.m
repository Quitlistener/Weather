//
//  NewsInternalBaseClass1.m
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "NewsInternalBaseClass1.h"
#import "NewsImgextra.h"
#import "NewsLiveInfo.h"
#import "NewsWapPortalV2.h"


NSString *const kNewsInternalBaseClass1Ptime = @"ptime";
NSString *const kNewsInternalBaseClass1Source = @"source";
NSString *const kNewsInternalBaseClass1Title = @"title";
NSString *const kNewsInternalBaseClass1Url = @"url";
NSString *const kNewsInternalBaseClass1Imgextra = @"imgextra";
NSString *const kNewsInternalBaseClass1TAG = @"TAG";
NSString *const kNewsInternalBaseClass1ImgType = @"imgType";
NSString *const kNewsInternalBaseClass1PhotosetID = @"photosetID";
NSString *const kNewsInternalBaseClass1Postid = @"postid";
NSString *const kNewsInternalBaseClass1HasHead = @"hasHead";
NSString *const kNewsInternalBaseClass1HasImg = @"hasImg";
NSString *const kNewsInternalBaseClass1Lmodify = @"lmodify";
NSString *const kNewsInternalBaseClass1Imgsrc = @"imgsrc";
NSString *const kNewsInternalBaseClass1Docid = @"docid";
NSString *const kNewsInternalBaseClass1Votecount = @"votecount";
NSString *const kNewsInternalBaseClass1ReplyCount = @"replyCount";
NSString *const kNewsInternalBaseClass1SkipType = @"skipType";
NSString *const kNewsInternalBaseClass1HasAD = @"hasAD";
NSString *const kNewsInternalBaseClass1Priority = @"priority";
NSString *const kNewsInternalBaseClass1Partner = @"partner";
NSString *const kNewsInternalBaseClass1CityType = @"cityType";
NSString *const kNewsInternalBaseClass1LiveInfo = @"live_info";
NSString *const kNewsInternalBaseClass1TAGS = @"TAGS";
NSString *const kNewsInternalBaseClass1Subtitle = @"subtitle";
NSString *const kNewsInternalBaseClass1Editor = @"editor";
NSString *const kNewsInternalBaseClass1SkipID = @"skipID";
NSString *const kNewsInternalBaseClass1Boardid = @"boardid";
NSString *const kNewsInternalBaseClass1Order = @"order";
NSString *const kNewsInternalBaseClass1Logo = @"logo";
NSString *const kNewsInternalBaseClass1Ad = @"ad";
NSString *const kNewsInternalBaseClass1WapPortalV2 = @"wap_portalV2";
NSString *const kNewsInternalBaseClass1Digest = @"digest";


@interface NewsInternalBaseClass1 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation NewsInternalBaseClass1

@synthesize ptime = _ptime;
@synthesize source = _source;
@synthesize title = _title;
@synthesize url = _url;
@synthesize imgextra = _imgextra;
@synthesize tAG = _tAG;
@synthesize imgType = _imgType;
@synthesize photosetID = _photosetID;
@synthesize postid = _postid;
@synthesize hasHead = _hasHead;
@synthesize hasImg = _hasImg;
@synthesize lmodify = _lmodify;
@synthesize imgsrc = _imgsrc;
@synthesize docid = _docid;
@synthesize votecount = _votecount;
@synthesize replyCount = _replyCount;
@synthesize skipType = _skipType;
@synthesize hasAD = _hasAD;
@synthesize priority = _priority;
@synthesize partner = _partner;
@synthesize cityType = _cityType;
@synthesize liveInfo = _liveInfo;
@synthesize tAGS = _tAGS;
@synthesize subtitle = _subtitle;
@synthesize editor = _editor;
@synthesize skipID = _skipID;
@synthesize boardid = _boardid;
@synthesize order = _order;
@synthesize logo = _logo;
@synthesize ad = _ad;
@synthesize wapPortalV2 = _wapPortalV2;
@synthesize digest = _digest;


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
            self.ptime = [self objectOrNilForKey:kNewsInternalBaseClass1Ptime fromDictionary:dict];
            self.source = [self objectOrNilForKey:kNewsInternalBaseClass1Source fromDictionary:dict];
            self.title = [self objectOrNilForKey:kNewsInternalBaseClass1Title fromDictionary:dict];
            self.url = [self objectOrNilForKey:kNewsInternalBaseClass1Url fromDictionary:dict];
    NSObject *receivedNewsImgextra = [dict objectForKey:kNewsInternalBaseClass1Imgextra];
    NSMutableArray *parsedNewsImgextra = [NSMutableArray array];
    if ([receivedNewsImgextra isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNewsImgextra) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNewsImgextra addObject:[NewsImgextra modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNewsImgextra isKindOfClass:[NSDictionary class]]) {
       [parsedNewsImgextra addObject:[NewsImgextra modelObjectWithDictionary:(NSDictionary *)receivedNewsImgextra]];
    }

    self.imgextra = [NSArray arrayWithArray:parsedNewsImgextra];
            self.tAG = [self objectOrNilForKey:kNewsInternalBaseClass1TAG fromDictionary:dict];
            self.imgType = [[self objectOrNilForKey:kNewsInternalBaseClass1ImgType fromDictionary:dict] doubleValue];
            self.photosetID = [self objectOrNilForKey:kNewsInternalBaseClass1PhotosetID fromDictionary:dict];
            self.postid = [self objectOrNilForKey:kNewsInternalBaseClass1Postid fromDictionary:dict];
            self.hasHead = [[self objectOrNilForKey:kNewsInternalBaseClass1HasHead fromDictionary:dict] doubleValue];
            self.hasImg = [[self objectOrNilForKey:kNewsInternalBaseClass1HasImg fromDictionary:dict] doubleValue];
            self.lmodify = [self objectOrNilForKey:kNewsInternalBaseClass1Lmodify fromDictionary:dict];
            self.imgsrc = [self objectOrNilForKey:kNewsInternalBaseClass1Imgsrc fromDictionary:dict];
            self.docid = [self objectOrNilForKey:kNewsInternalBaseClass1Docid fromDictionary:dict];
            self.votecount = [[self objectOrNilForKey:kNewsInternalBaseClass1Votecount fromDictionary:dict] doubleValue];
            self.replyCount = [[self objectOrNilForKey:kNewsInternalBaseClass1ReplyCount fromDictionary:dict] doubleValue];
            self.skipType = [self objectOrNilForKey:kNewsInternalBaseClass1SkipType fromDictionary:dict];
            self.hasAD = [[self objectOrNilForKey:kNewsInternalBaseClass1HasAD fromDictionary:dict] doubleValue];
            self.priority = [[self objectOrNilForKey:kNewsInternalBaseClass1Priority fromDictionary:dict] doubleValue];
            self.partner = [self objectOrNilForKey:kNewsInternalBaseClass1Partner fromDictionary:dict];
            self.cityType = [[self objectOrNilForKey:kNewsInternalBaseClass1CityType fromDictionary:dict] doubleValue];
            self.liveInfo = [NewsLiveInfo modelObjectWithDictionary:[dict objectForKey:kNewsInternalBaseClass1LiveInfo]];
            self.tAGS = [self objectOrNilForKey:kNewsInternalBaseClass1TAGS fromDictionary:dict];
            self.subtitle = [self objectOrNilForKey:kNewsInternalBaseClass1Subtitle fromDictionary:dict];
            self.editor = [self objectOrNilForKey:kNewsInternalBaseClass1Editor fromDictionary:dict];
            self.skipID = [self objectOrNilForKey:kNewsInternalBaseClass1SkipID fromDictionary:dict];
            self.boardid = [self objectOrNilForKey:kNewsInternalBaseClass1Boardid fromDictionary:dict];
            self.order = [[self objectOrNilForKey:kNewsInternalBaseClass1Order fromDictionary:dict] doubleValue];
            self.logo = [self objectOrNilForKey:kNewsInternalBaseClass1Logo fromDictionary:dict];
            self.ad = [self objectOrNilForKey:kNewsInternalBaseClass1Ad fromDictionary:dict];
    NSObject *receivedNewsWapPortalV2 = [dict objectForKey:kNewsInternalBaseClass1WapPortalV2];
    NSMutableArray *parsedNewsWapPortalV2 = [NSMutableArray array];
    if ([receivedNewsWapPortalV2 isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedNewsWapPortalV2) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedNewsWapPortalV2 addObject:[NewsWapPortalV2 modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedNewsWapPortalV2 isKindOfClass:[NSDictionary class]]) {
       [parsedNewsWapPortalV2 addObject:[NewsWapPortalV2 modelObjectWithDictionary:(NSDictionary *)receivedNewsWapPortalV2]];
    }

    self.wapPortalV2 = [NSArray arrayWithArray:parsedNewsWapPortalV2];
            self.digest = [self objectOrNilForKey:kNewsInternalBaseClass1Digest fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ptime forKey:kNewsInternalBaseClass1Ptime];
    [mutableDict setValue:self.source forKey:kNewsInternalBaseClass1Source];
    [mutableDict setValue:self.title forKey:kNewsInternalBaseClass1Title];
    [mutableDict setValue:self.url forKey:kNewsInternalBaseClass1Url];
    NSMutableArray *tempArrayForImgextra = [NSMutableArray array];
    for (NSObject *subArrayObject in self.imgextra) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForImgextra addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForImgextra addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForImgextra] forKey:kNewsInternalBaseClass1Imgextra];
    [mutableDict setValue:self.tAG forKey:kNewsInternalBaseClass1TAG];
    [mutableDict setValue:[NSNumber numberWithDouble:self.imgType] forKey:kNewsInternalBaseClass1ImgType];
    [mutableDict setValue:self.photosetID forKey:kNewsInternalBaseClass1PhotosetID];
    [mutableDict setValue:self.postid forKey:kNewsInternalBaseClass1Postid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hasHead] forKey:kNewsInternalBaseClass1HasHead];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hasImg] forKey:kNewsInternalBaseClass1HasImg];
    [mutableDict setValue:self.lmodify forKey:kNewsInternalBaseClass1Lmodify];
    [mutableDict setValue:self.imgsrc forKey:kNewsInternalBaseClass1Imgsrc];
    [mutableDict setValue:self.docid forKey:kNewsInternalBaseClass1Docid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.votecount] forKey:kNewsInternalBaseClass1Votecount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.replyCount] forKey:kNewsInternalBaseClass1ReplyCount];
    [mutableDict setValue:self.skipType forKey:kNewsInternalBaseClass1SkipType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.hasAD] forKey:kNewsInternalBaseClass1HasAD];
    [mutableDict setValue:[NSNumber numberWithDouble:self.priority] forKey:kNewsInternalBaseClass1Priority];
    [mutableDict setValue:self.partner forKey:kNewsInternalBaseClass1Partner];
    [mutableDict setValue:[NSNumber numberWithDouble:self.cityType] forKey:kNewsInternalBaseClass1CityType];
    [mutableDict setValue:[self.liveInfo dictionaryRepresentation] forKey:kNewsInternalBaseClass1LiveInfo];
    [mutableDict setValue:self.tAGS forKey:kNewsInternalBaseClass1TAGS];
    [mutableDict setValue:self.subtitle forKey:kNewsInternalBaseClass1Subtitle];
    NSMutableArray *tempArrayForEditor = [NSMutableArray array];
    for (NSObject *subArrayObject in self.editor) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForEditor addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForEditor addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForEditor] forKey:kNewsInternalBaseClass1Editor];
    [mutableDict setValue:self.skipID forKey:kNewsInternalBaseClass1SkipID];
    [mutableDict setValue:self.boardid forKey:kNewsInternalBaseClass1Boardid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.order] forKey:kNewsInternalBaseClass1Order];
    [mutableDict setValue:self.logo forKey:kNewsInternalBaseClass1Logo];
    NSMutableArray *tempArrayForAd = [NSMutableArray array];
    for (NSObject *subArrayObject in self.ad) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAd addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAd addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAd] forKey:kNewsInternalBaseClass1Ad];
    NSMutableArray *tempArrayForWapPortalV2 = [NSMutableArray array];
    for (NSObject *subArrayObject in self.wapPortalV2) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForWapPortalV2 addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForWapPortalV2 addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForWapPortalV2] forKey:kNewsInternalBaseClass1WapPortalV2];
    [mutableDict setValue:self.digest forKey:kNewsInternalBaseClass1Digest];

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

    self.ptime = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Ptime];
    self.source = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Source];
    self.title = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Title];
    self.url = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Url];
    self.imgextra = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Imgextra];
    self.tAG = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1TAG];
    self.imgType = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1ImgType];
    self.photosetID = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1PhotosetID];
    self.postid = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Postid];
    self.hasHead = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1HasHead];
    self.hasImg = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1HasImg];
    self.lmodify = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Lmodify];
    self.imgsrc = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Imgsrc];
    self.docid = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Docid];
    self.votecount = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1Votecount];
    self.replyCount = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1ReplyCount];
    self.skipType = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1SkipType];
    self.hasAD = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1HasAD];
    self.priority = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1Priority];
    self.partner = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Partner];
    self.cityType = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1CityType];
    self.liveInfo = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1LiveInfo];
    self.tAGS = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1TAGS];
    self.subtitle = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Subtitle];
    self.editor = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Editor];
    self.skipID = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1SkipID];
    self.boardid = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Boardid];
    self.order = [aDecoder decodeDoubleForKey:kNewsInternalBaseClass1Order];
    self.logo = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Logo];
    self.ad = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Ad];
    self.wapPortalV2 = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1WapPortalV2];
    self.digest = [aDecoder decodeObjectForKey:kNewsInternalBaseClass1Digest];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_ptime forKey:kNewsInternalBaseClass1Ptime];
    [aCoder encodeObject:_source forKey:kNewsInternalBaseClass1Source];
    [aCoder encodeObject:_title forKey:kNewsInternalBaseClass1Title];
    [aCoder encodeObject:_url forKey:kNewsInternalBaseClass1Url];
    [aCoder encodeObject:_imgextra forKey:kNewsInternalBaseClass1Imgextra];
    [aCoder encodeObject:_tAG forKey:kNewsInternalBaseClass1TAG];
    [aCoder encodeDouble:_imgType forKey:kNewsInternalBaseClass1ImgType];
    [aCoder encodeObject:_photosetID forKey:kNewsInternalBaseClass1PhotosetID];
    [aCoder encodeObject:_postid forKey:kNewsInternalBaseClass1Postid];
    [aCoder encodeDouble:_hasHead forKey:kNewsInternalBaseClass1HasHead];
    [aCoder encodeDouble:_hasImg forKey:kNewsInternalBaseClass1HasImg];
    [aCoder encodeObject:_lmodify forKey:kNewsInternalBaseClass1Lmodify];
    [aCoder encodeObject:_imgsrc forKey:kNewsInternalBaseClass1Imgsrc];
    [aCoder encodeObject:_docid forKey:kNewsInternalBaseClass1Docid];
    [aCoder encodeDouble:_votecount forKey:kNewsInternalBaseClass1Votecount];
    [aCoder encodeDouble:_replyCount forKey:kNewsInternalBaseClass1ReplyCount];
    [aCoder encodeObject:_skipType forKey:kNewsInternalBaseClass1SkipType];
    [aCoder encodeDouble:_hasAD forKey:kNewsInternalBaseClass1HasAD];
    [aCoder encodeDouble:_priority forKey:kNewsInternalBaseClass1Priority];
    [aCoder encodeObject:_partner forKey:kNewsInternalBaseClass1Partner];
    [aCoder encodeDouble:_cityType forKey:kNewsInternalBaseClass1CityType];
    [aCoder encodeObject:_liveInfo forKey:kNewsInternalBaseClass1LiveInfo];
    [aCoder encodeObject:_tAGS forKey:kNewsInternalBaseClass1TAGS];
    [aCoder encodeObject:_subtitle forKey:kNewsInternalBaseClass1Subtitle];
    [aCoder encodeObject:_editor forKey:kNewsInternalBaseClass1Editor];
    [aCoder encodeObject:_skipID forKey:kNewsInternalBaseClass1SkipID];
    [aCoder encodeObject:_boardid forKey:kNewsInternalBaseClass1Boardid];
    [aCoder encodeDouble:_order forKey:kNewsInternalBaseClass1Order];
    [aCoder encodeObject:_logo forKey:kNewsInternalBaseClass1Logo];
    [aCoder encodeObject:_ad forKey:kNewsInternalBaseClass1Ad];
    [aCoder encodeObject:_wapPortalV2 forKey:kNewsInternalBaseClass1WapPortalV2];
    [aCoder encodeObject:_digest forKey:kNewsInternalBaseClass1Digest];
}

- (id)copyWithZone:(NSZone *)zone
{
    NewsInternalBaseClass1 *copy = [[NewsInternalBaseClass1 alloc] init];
    
    if (copy) {

        copy.ptime = [self.ptime copyWithZone:zone];
        copy.source = [self.source copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.imgextra = [self.imgextra copyWithZone:zone];
        copy.tAG = [self.tAG copyWithZone:zone];
        copy.imgType = self.imgType;
        copy.photosetID = [self.photosetID copyWithZone:zone];
        copy.postid = [self.postid copyWithZone:zone];
        copy.hasHead = self.hasHead;
        copy.hasImg = self.hasImg;
        copy.lmodify = [self.lmodify copyWithZone:zone];
        copy.imgsrc = [self.imgsrc copyWithZone:zone];
        copy.docid = [self.docid copyWithZone:zone];
        copy.votecount = self.votecount;
        copy.replyCount = self.replyCount;
        copy.skipType = [self.skipType copyWithZone:zone];
        copy.hasAD = self.hasAD;
        copy.priority = self.priority;
        copy.partner = [self.partner copyWithZone:zone];
        copy.cityType = self.cityType;
        copy.liveInfo = [self.liveInfo copyWithZone:zone];
        copy.tAGS = [self.tAGS copyWithZone:zone];
        copy.subtitle = [self.subtitle copyWithZone:zone];
        copy.editor = [self.editor copyWithZone:zone];
        copy.skipID = [self.skipID copyWithZone:zone];
        copy.boardid = [self.boardid copyWithZone:zone];
        copy.order = self.order;
        copy.logo = [self.logo copyWithZone:zone];
        copy.ad = [self.ad copyWithZone:zone];
        copy.wapPortalV2 = [self.wapPortalV2 copyWithZone:zone];
        copy.digest = [self.digest copyWithZone:zone];
    }
    
    return copy;
}


@end
