//
//  UserProfileManager.m
//  jsce
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "UserProfileManager.h"

#define kCURRENT_USERNAME [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername]

static UserProfileManager *sharedInstance = nil;
@interface UserProfileManager ()
{
    NSString *_curusername;
     NSUserDefaults *_defaults;
}

@property (nonatomic, strong) NSMutableDictionary *users;

@end

@implementation UserProfileManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
         _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


-(void)addMember:(UserProfileEntity *)entity loginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"member"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    [appleys addObject:entity];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(void)removeMember:(UserProfileEntity *)entity loginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"member"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(NSArray *)contactListWithloginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"member"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}



/*-----------------------------------------------------------------------------------------------*/

/*
 *  上传个人头像
 */
- (void)uploadUserHeadImageProfileInBackground:(UIImage*)image
                                    completion:(void (^)(BOOL success, NSError *error))completion{
    
}

/*
 *  上传个人信息
 */
- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion{
    
}

/*
 *  获取用户信息 by username
 */
- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion{
    
}

/*
 *  获取用户信息 by buddy
 */
- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion{
    
}

/*
 *  获取本地用户信息
 */
- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username{
    
    if ([_users objectForKey:username]) {
        return [_users objectForKey:username];
    }
    
    return nil;
}

/*
 *  获取当前用户信息
 */
- (UserProfileEntity*)getCurUserProfile{
    
    if ([_users objectForKey:kCURRENT_USERNAME]) {
        return [_users objectForKey:kCURRENT_USERNAME];
    }
    
    return nil;
}

/*
 *  根据username获取当前用户昵称
 */
- (NSString*)getNickNameWithUsername:(NSString*)username{
    UserProfileEntity* entity = [self getUserProfileByUsername:username];
    if (entity.nickname && entity.nickname.length > 0) {
        return entity.nickname;
    } else {
        return username;
    }
}

@end

@implementation UserProfileEntity

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_objectId forKey:@"objectId"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:_image forKey:@"image"];

}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        _objectId = [aDecoder decodeObjectForKey:@"objectId"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        _image = [aDecoder decodeObjectForKey:@"image"];
        
        
    }
    
    return self;
}

@end


