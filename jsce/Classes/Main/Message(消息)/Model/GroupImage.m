
//
//  GroupImage.m
//  jsce
//
//  Created by mac on 15/10/23.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "GroupImage.h"


static GroupImage *sharedInstance = nil;
@implementation GroupImage{
    NSUserDefaults *_defaults;
}



+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

-(void)addGroup:(GroupName *)applyEntity loginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"group"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];
    [appleys addObject:applyEntity];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(void)removeGroup:(GroupName *)applyEntity loginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"group"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    NSMutableArray *appleys = [[NSMutableArray alloc] initWithArray:ary];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:appleys];
    [_defaults setObject:data forKey:username];
}

-(NSArray *)groupWithloginUser:(NSString *)username{
    username  = [username stringByAppendingString:@"group"];
    NSData *defalutData = [_defaults objectForKey:username];
    NSArray *ary = [NSKeyedUnarchiver unarchiveObjectWithData:defalutData];
    return ary;
}

@end


@interface GroupName ()<NSCoding>

@end

@implementation GroupName

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_groupId forKey:@"groupId"];

    [aCoder encodeObject:_image forKey:@"image"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){

        _groupId = [aDecoder decodeObjectForKey:@"groupId"];

        _image = [aDecoder decodeObjectForKey:@"image"];
    }
    
    return self;
}

@end


