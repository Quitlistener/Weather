//
//  NetWorkRequest.m
//  项目01 9_9
//
//  Created by lanou on 16/9/12.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "NetWorkRequest.h"

@implementation NetWorkRequest

+(void)requestWithMethod:(RequestType)method URL:(NSString *)RequestUrl para:(NSDictionary *)paraDic success:(success)suc error:(failed)failerror
{
    
    NSURLSession *session = [NSURLSession   sharedSession];
    NSMutableURLRequest *mutUrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:RequestUrl]];
    
    /** 这是Get请求时必须要有apikey参数时 */
    [mutUrlRequest setValue:@"e3341ef8fa563d004e4132b74bf788d8" forHTTPHeaderField:@"apikey"];
    
    if (method == POST) {
        mutUrlRequest.HTTPMethod = @"POST";
        mutUrlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:paraDic options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSURLSessionTask *task = [session dataTaskWithRequest:mutUrlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            suc(data);//可以加一个HUD提示正在加载 提高用户体验
        }
        else{
            failerror(error);
        }
    }];
    [task resume];
}




@end
