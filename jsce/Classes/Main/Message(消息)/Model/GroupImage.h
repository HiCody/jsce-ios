//
//  GroupImage.h
//  jsce
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GroupName;
@interface GroupImage : NSObject
+ (instancetype)sharedInstance;
-(void)addGroup:(GroupName *)applyEntity loginUser:(NSString *)username;
-(void)removeGroup:(GroupName *)applyEntity loginUser:(NSString *)username;
-(NSArray *)groupWithloginUser:(NSString *)username;
@end


@interface GroupName : NSObject


@property (nonatomic,strong) NSString *groupId;
@property (nonatomic, strong) UIImage * image;

@end