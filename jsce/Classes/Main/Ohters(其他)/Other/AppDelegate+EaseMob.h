//
//  AppDelegate+EaseMob.h
//  jsce
//
//  Created by mac on 15/10/8.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (EaseMob)
/**
 *  本类中做了EaseMob初始化和推送等操作
 */
- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
