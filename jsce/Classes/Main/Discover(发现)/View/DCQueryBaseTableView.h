//
//  DCQueryBaseTableView.h
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCQueryBaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;

@end
