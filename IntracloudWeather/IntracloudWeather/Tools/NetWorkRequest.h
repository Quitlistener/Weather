//
//  NetWorkRequest.h
//  项目01 9_9
//
//  Created by lanou on 16/9/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkRequest : NSObject

typedef NS_ENUM(NSInteger, RequestType) {
   GET = 0,
    POST = 1
};

typedef void(^success)(NSData *data);
typedef void(^failed)(NSError *error);
+(void)requestWithMethod:(RequestType)method URL:(NSString *)RequestUrl para:(NSDictionary *)paraDic success:(success)suc error:(failed)failerror;

@end
