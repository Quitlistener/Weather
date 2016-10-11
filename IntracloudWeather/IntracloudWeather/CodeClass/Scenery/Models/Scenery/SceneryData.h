//
//  SceneryData.h
//
//  Created by   on 2016/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SceneryData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *books;
@property (nonatomic, assign) double count;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
