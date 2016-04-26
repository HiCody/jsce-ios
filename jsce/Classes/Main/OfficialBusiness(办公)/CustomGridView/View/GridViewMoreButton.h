//
//  GridViewMoreButton.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewListItemButton.h"
#import "GridItemModel.h"
@interface GridViewMoreButton : UIButton

@property (nonatomic, strong) GridItemModel *itemModel;
@property (nonatomic,strong)  GridViewListItemButton *button;

@end
