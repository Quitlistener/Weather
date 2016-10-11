//
//  SceneryBooks.h
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SceneryBooks : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *bookUrl;
@property (nonatomic, strong) NSString *headImage;
@property (nonatomic, assign) double bookImgNum;
@property (nonatomic, assign) double likeCount;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, assign) double viewCount;
@property (nonatomic, strong) NSString *userHeadImg;
@property (nonatomic, assign) double commentCount;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL elite;
@property (nonatomic, assign) double routeDays;
@property (nonatomic, strong) NSString *startTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
