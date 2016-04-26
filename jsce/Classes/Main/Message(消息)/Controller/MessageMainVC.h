//
//  MessageMainVC.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"

@interface MessageMainVC : JsceBaseVC
@property(strong,nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSString *notificationTitle;//通知详细


//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;
@end
