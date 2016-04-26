//
//  MMMessageModel.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMMessageModel.h"

@implementation MMMessageModel


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //code
    }
    
    return self;
}

- (void)dealloc{
    
}

- (NSString *)messageId
{
    return _message.messageId;
}

- (MessageDeliveryState)status
{
    return _message.deliveryState;
}

@end
