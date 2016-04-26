//
//  DCDownloadTVC.h
//  jsce
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsceBaseTableView.h"
#import "DCDownloadFootView.h"
@interface DCDownloadTVC : JsceBaseTableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *titleStr;

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,strong)NSString *fileSizeStr;

@property(nonatomic,strong)DCDownloadFootView *downloadFV;

@end
