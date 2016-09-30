//
//  NewsLiveInfo.h
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewsLiveInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double roomId;
@property (nonatomic, assign) double userCount;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) BOOL pano;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) BOOL mutilVideo;
@property (nonatomic, assign) double remindTag;
@property (nonatomic, assign) double type;
@property (nonatomic, assign) BOOL video;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
