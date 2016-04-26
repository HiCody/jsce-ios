//
//  UserProfileManager.h
//  jsce
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPARSE_HXUSER @"hxuser"
#define kPARSE_HXUSER_USERNAME @"username"
#define kPARSE_HXUSER_NICKNAME @"nickname"
#define kPARSE_HXUSER_AVATAR @"avatar"

@class UserProfileEntity;

@interface UserProfileManager : NSObject

-(void)addMember:(UserProfileEntity *)entity loginUser:(NSString *)username;

-(void)removeMember:(UserProfileEntity *)entity loginUser:(NSString *)username;

-(NSArray *)contactListWithloginUser:(NSString *)username;

/*-----------------------------------------------------------------------------------------------*/

+ (instancetype)sharedInstance;
/*
 *  上传个人头像
 */
- (void)uploadUserHeadImageProfileInBackground:(UIImage*)image
                                    completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  上传个人信息
 */
- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取用户信息 by username
 */
- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取用户信息 by buddy
 */
- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion;

/*
 *  获取本地用户信息
 */
- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username;

/*
 *  获取当前用户信息
 */
- (UserProfileEntity*)getCurUserProfile;

/*
 *  根据username获取当前用户昵称
 */
- (NSString*)getNickNameWithUsername:(NSString*)username;

@end

@interface UserProfileEntity : NSObject<NSCoding>


@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic, assign) BOOL disabled; //是否不让选择
@property (nonatomic, assign) BOOL selected; //是否已经被选择


@end
