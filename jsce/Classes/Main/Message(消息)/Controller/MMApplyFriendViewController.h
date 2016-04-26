//
//  MMApplyFriendViewController.h
//  jsce
//
//  Created by mac on 15/10/13.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface MMApplyFriendViewController : JsceBaseVC

@property(nonatomic,strong)NSMutableArray *dataSource;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;

@end
