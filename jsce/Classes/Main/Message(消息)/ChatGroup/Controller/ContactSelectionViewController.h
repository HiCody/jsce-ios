//
//  ContactSelectionViewController.h
//  jsce
//
//  Created by mac on 15/10/20.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"

@interface ContactSelectionViewController : JsceBaseVC

//已有选中的成员username，在该页面，这些成员不能被取消选择
- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames;

@end
