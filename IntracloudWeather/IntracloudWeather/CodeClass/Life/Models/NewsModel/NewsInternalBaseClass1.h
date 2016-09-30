//
//  NewsInternalBaseClass1.h
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsLiveInfo;

@interface NewsInternalBaseClass1 : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *imgextra;
@property (nonatomic, strong) NSString *tAG;
@property (nonatomic, assign) double imgType;
@property (nonatomic, strong) NSString *photosetID;
@property (nonatomic, strong) NSString *postid;
@property (nonatomic, assign) double hasHead;
@property (nonatomic, assign) double hasImg;
@property (nonatomic, strong) NSString *lmodify;
@property (nonatomic, strong) NSString *imgsrc;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, assign) double votecount;
@property (nonatomic, assign) double replyCount;
@property (nonatomic, strong) NSString *skipType;
@property (nonatomic, assign) double hasAD;
@property (nonatomic, assign) double priority;
@property (nonatomic, strong) NSString *partner;
@property (nonatomic, assign) double cityType;
@property (nonatomic, strong) NewsLiveInfo *liveInfo;
@property (nonatomic, strong) NSString *tAGS;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSArray *editor;
@property (nonatomic, strong) NSString *skipID;
@property (nonatomic, strong) NSString *boardid;
@property (nonatomic, assign) double order;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *wapPortalV2;
@property (nonatomic, strong) NSString *digest;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
