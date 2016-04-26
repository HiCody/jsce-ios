//
//  Organization.h
//  建信
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OrganizationContent : NSObject

@property (nonatomic, copy) NSString *rights;

@property (nonatomic, assign) NSInteger responser;

@property (nonatomic, copy) NSString *responserCode;

@property (nonatomic, copy) NSString *orgId;

@property (nonatomic, copy) NSString *orgName;

@property (nonatomic, copy) NSString *topOrgId;

@property (nonatomic, assign) BOOL topGroup;

@property (nonatomic, copy) NSString *topOrgName;

@property (nonatomic, copy) NSString *responserDisp;

@end

@interface Organization : NSObject

@property(nonatomic,strong)NSArray *organizationArr;

@property(nonatomic,strong)NSArray *topOrgIdArr;

@property(nonatomic,strong)NSArray *rightsArr;

+ (instancetype)shareOrganization;

@end
