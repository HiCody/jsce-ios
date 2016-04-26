//
//  UserInfo.m
//  建信
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 yuantu. All rights reserved.
//

#import "UserInfo.h"
static id shareUserInfo;
@implementation UserInfo

+ (instancetype)shareUserInfo
{
    if (shareUserInfo == nil) {
        shareUserInfo = [[UserInfo alloc] init];
    }
    
    return shareUserInfo;
}

@end
