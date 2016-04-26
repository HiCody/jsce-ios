//
//  GridViewListItemView.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridItemModel.h"

@class GridViewListItemView;
typedef void(^buttonClickedOperationBlock)(GridViewListItemView *item);
typedef void(^itemLongPressedOperationBlock)(UILongPressGestureRecognizer *longPressed);;
typedef void(^iconViewClickedOperationBlock)(GridViewListItemView *view);


@interface GridViewListItemView : UIView
@property (nonatomic, strong) GridItemModel *itemModel;
@property (nonatomic, assign) BOOL hidenIcon;
@property (nonatomic, strong) UIImage *iconImage;

@property(nonatomic,copy)buttonClickedOperationBlock buttonClickedOperationBlock;
@property(nonatomic,copy)itemLongPressedOperationBlock itemLongPressedOperationBlock;
@property(nonatomic,copy)iconViewClickedOperationBlock iconViewClickedOperationBlock;
@end
