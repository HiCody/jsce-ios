//
//  JsceBaseTableView.h
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
typedef NS_ENUM(NSInteger, TypeStyle){
    Loading,
    NoData,
    NoNetWork,
    
};
@interface JsceBaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,assign)TypeStyle typeStyle;

@property (nonatomic, getter=isLoading) BOOL loading;

@property(nonatomic,copy)void(^refresh)();
@property(nonatomic,copy)void(^loadingData)();

- (void)reloadEmptyDataSetWithTypeStyle:(TypeStyle)typeStyle;

@end
