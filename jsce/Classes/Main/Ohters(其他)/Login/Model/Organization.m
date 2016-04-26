
//
//  Organization.m
//  建信
//
//  Created by mac on 15/8/25.
//  Copyright (c) 2015年 yuantu. All rights reserved.
//

#import "Organization.h"
static id shareOrganization;

@implementation OrganizationContent



@end

@implementation Organization

+ (instancetype)shareOrganization
{
    if (shareOrganization == nil) {
        shareOrganization = [[Organization alloc] init];
    }
    
    return shareOrganization;
}

@end
