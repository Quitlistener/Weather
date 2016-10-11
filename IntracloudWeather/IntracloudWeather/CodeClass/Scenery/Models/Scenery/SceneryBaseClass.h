//
//  SceneryBaseClass.h
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SceneryData;

@interface SceneryBaseClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double errcode;
@property (nonatomic, strong) SceneryData *data;
@property (nonatomic, assign) double ver;
@property (nonatomic, strong) NSString *errmsg;
@property (nonatomic, assign) BOOL ret;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
