//
//  NewsWapPortalV2.h
//
//  Created by   on 2016/9/29
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NewsWapPortalV2 : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *wapUrl;
@property (nonatomic, strong) NSString *wapTitle;
@property (nonatomic, strong) NSString *wapImg;
@property (nonatomic, strong) NSString *wapDesc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
