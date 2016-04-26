//
//  OfficialBusiness.h
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficialBusiness : NSObject

+ (void)commitUserInfoAfterChangedWithRealName:(NSString *)name Email:(NSString *)email Phone:(NSString *)phone success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;

@end
