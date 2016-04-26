

//
//  LoginModel.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "LoginModel.h"
typedef void (^judgePartsShow)(NSArray *organizationArr);
static id shareAccount;

@implementation Account
+ (instancetype)shareAccount
{
    if (shareAccount == nil) {
        shareAccount = [[Account alloc] init];
    }
    
    return shareAccount;
}

- (void)saveAccountToSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    [userdefault setObject:self.userName forKey:K_UserName];
    [userdefault setObject:self.passWord forKey:K_PassWord];
    [userdefault setObject:self.shock forKey:K_Shock];
    [userdefault setObject:self.sound forKey:K_Sound];
    [userdefault synchronize];
}


- (void)loadAccountFromSanbox{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    
    self.userName = [userdefault objectForKey:K_UserName];
    
    self.passWord = [userdefault objectForKey:K_PassWord];
    
    self.shock=[userdefault objectForKey:K_Shock];
    
    self.sound=[userdefault objectForKey:K_Sound];
    
}

@end

@implementation LoginModel

+ (void)doLogin:(NSString*)name pwd:(NSString*)pwd success:(void(^)(AFHTTPRequestOperation* operation, id result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = LOGINCHECKWEB;
    NSDictionary *parameters=@{@"userName":name,@"passWord":pwd,@"platForm":@"3"};

    [[XBApi SharedXBApi] requestWithURL:url paras:parameters type:XBHttpResponseType_Common success:success    failure:failure];
}


//组织切换判断接口
+ (void)organizationChange:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure
{
    [[Account shareAccount] loadAccountFromSanbox];
    NSString *user=[Account shareAccount].userName;
    NSString *passWord=[Account shareAccount].passWord;
    NSDictionary *paratemers=@{@"userName":user,
                               @"passWord":passWord,
                               @"platForm":@"3"};
    [[XBApi SharedXBApi] requestWithURL:ORGANIZATIONCHANGEWEB paras:paratemers type:XBHttpResponseType_Common success:success    failure:failure];
}

//应用页面模块在不同权限下的隐藏和显示
+ (BOOL)judgeApplicationPartsWithRights:(NSString *)rights{
    NSString *evaluateRight=@"1022";
    NSRange range=[evaluateRight rangeOfString:evaluateRight];
    if (range.location == NSNotFound) {
        return NO;
    }
    return YES;
}

//+ (void)organizationChangeWithJudgePartsShow:(judgePartsShow)judgePartsShow{
//    NSString *user=[Account shareAccount].userName;
//    NSString *passWord=[Account shareAccount].passWord;
//    NSDictionary *paratemers=@{@"userName":user,
//                               @"passWord":passWord,
//                               @"platForm":@"3"};
//    
//    [NetRequestClass NetRequestPOSTWithRequestURL:ORGANIZATIONCHANGEWEB WithParameter:paratemers WithReturnValeuBlock:^(id returnValue) {
//        
//        NSDictionary *dict=returnValue;
//        NSArray *tempArr= dict[@"items"];
//        
//        
//        NSArray *arr=[OrganizationContent objectArrayWithKeyValuesArray:tempArr];
//        
//        //  BOOL isShow=[self judgeApplicationPartsWithRights:dict[@"rights"]];
//        
//        
//        if (judgePartsShow) {
//            judgePartsShow(arr);
//        }
//        
//        
//    } WithErrorCodeBlock:^(id errorCode) {
//        
//    } WithFailureBlock:^{
//        
//    }];
//}

@end
