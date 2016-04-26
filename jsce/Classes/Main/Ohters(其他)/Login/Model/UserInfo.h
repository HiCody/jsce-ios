//
//  UserInfo.h
//  建信
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfo : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *responserDisp;

@property (nonatomic, copy) NSString *syncDisp;

@property (nonatomic, assign) BOOL topGroup;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *userOrgInfoList;

@property (nonatomic, copy ,getter = theNewPasswd) NSString *newPassWd;

@property (nonatomic, copy) NSString *lastLoginOrgId;

@property (nonatomic, copy) NSString *topOrgName;

@property (nonatomic, copy) NSString *lastLoginTimeDisp;

@property (nonatomic, copy) NSString *responserCode;

@property (nonatomic, copy) NSString *topOrgId;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, assign) NSInteger sync;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *lastLoginTime;

@property (nonatomic, assign) NSInteger responser;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *passwd;

@property (nonatomic, copy) NSString *statusDisp;

@property (nonatomic, copy) NSString *orgName;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *orgId;

@property (nonatomic, copy) NSString *rights;

@property (nonatomic, copy) NSString *lastLoginIp;

@property (nonatomic, assign) NSInteger userId;

+ (instancetype)shareUserInfo;

@end

