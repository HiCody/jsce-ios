//
//  ChatGroupDetailViewController.h
//  jsce
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"
/**
 *  群组成员类型
 */
typedef enum{
    GroupOccupantTypeOwner,//创建者
    GroupOccupantTypeMember,//成员
}GroupOccupantType;

@interface ChatGroupDetailViewController : JsceBaseVC

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

- (instancetype)initWithGroupId:(NSString *)chatGroupId;

@end
