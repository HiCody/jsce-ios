//
//  InvitationManager.h
//  jsce
//
//  Created by mac on 15/10/13.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApplyEntity;
@interface InvitationManager : NSObject

+ (instancetype)sharedInstance;

-(void)addInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(void)removeInvitation:(ApplyEntity *)applyEntity loginUser:(NSString *)username;

-(NSArray *)applyEmtitiesWithloginUser:(NSString *)username;

@end

@interface ApplyEntity : NSObject

@property (nonatomic, strong) NSString * applicantUsername;
@property (nonatomic, strong) NSString * applicantNick;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic, strong) NSString * receiverUsername;
@property (nonatomic, strong) NSString * receiverNick;
@property (nonatomic, strong) NSNumber * style;
@property (nonatomic, strong) NSString * groupId;
@property (nonatomic, strong) NSString * groupSubject;
@property (nonatomic, strong) UIImage * image;

@end

