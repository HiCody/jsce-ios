//
//  XBApi.m
//  XBHttpClient
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/30.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "XBApi.h"

@interface XBApi()
{
    XBHttpClient *http_common ;
    XBHttpClient *http_json ;
}

@end

@implementation XBApi

+ (instancetype)SharedXBApi
{
    static XBApi* xb = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        xb = [[XBApi alloc] init];
    });
    return xb;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        http_common = [[XBHttpClient alloc] init];
        AFHTTPRequestSerializer* request_common = [[AFHTTPRequestSerializer alloc] init];
        [request_common setValue:@"true" forHTTPHeaderField:@"IsMobile"];
        [http_common setRequestSerializer:request_common];
    }
    return self;
}

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure
{
    if(type == XBHttpResponseType_Common){
       
        [http_common requestWithURL:url paras:parasDict type:type success:success failure:failure];
    }
}

@end
