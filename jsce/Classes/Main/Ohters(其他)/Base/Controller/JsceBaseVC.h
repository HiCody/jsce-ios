//
//  JsceBaseVC.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBBaseVC.h"
@interface JsceBaseVC : XBBaseVC

#pragma mark - Empty
- (void)showEmpty;
- (void)showEmpty:(CGRect)frame;
- (void)hideEmpty;

#pragma mark - load
- (void)showLoad;
- (void)hideLoad;


@end
