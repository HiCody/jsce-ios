
//
//  OfficialBusiness.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "OfficialBusiness.h"

@implementation OfficialBusiness

//保存变更后的用户信息
+ (void)commitUserInfoAfterChangedWithRealName:(NSString *)name Email:(NSString *)email Phone:(NSString *)phone success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure{
    
    [[Account shareAccount] loadAccountFromSanbox];
    NSString *user=[Account shareAccount].userName;
    NSString *passWord=[Account shareAccount].passWord;
    NSString *userId=[NSString stringWithFormat:@"%li",[UserInfo shareUserInfo].userId];
    NSDictionary *params=@{@"userName":user,
                           @"passWord":passWord,
                           @"platForm":@"3",
                           @"userId":userId,
                           @"realName":name,
                           @"email":email,
                           @"phone":phone};
    NSString *url=COMMITUSERINFOWEB;
    
    [[XBApi SharedXBApi] requestWithURL:url paras:params type:XBHttpResponseType_Common success:success failure:failure];
    
}
@end
