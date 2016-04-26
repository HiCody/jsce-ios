//
//  AppDelegate.h
//  jsce
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsceTarBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) JsceTarBarController *jsceTBC;


- (void)LoginIn;

- (void)signOut;
@end

