//
//  JsceTarBarController.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsceNavigationController.h"
@interface JsceTarBarController : UITabBarController{
    EMConnectionState _connectionState;
}

- (void)networkChanged:(EMConnectionState)connectionState;

@end
