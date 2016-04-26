//
//  LoginModel.h
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define K_UserName @"userName"
#define K_PassWord @"passWord"
#define K_Shock    @"isShock"
#define K_Sound    @"isSound"
@interface Account : NSObject

@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *passWord;//密码
@property (nonatomic,copy)NSString *shock;
@property (nonatomic,copy)NSString *sound;
+ (instancetype)shareAccount;

- (void)saveAccountToSanbox;

-(void)loadAccountFromSanbox;

@end

@interface LoginModel : NSObject

+ (void)doLogin:(NSString*)name pwd:(NSString*)pwd success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;

+ (void)organizationChange:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;
@end
