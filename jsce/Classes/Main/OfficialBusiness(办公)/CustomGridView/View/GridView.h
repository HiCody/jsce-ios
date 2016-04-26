//
//  GridView.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridView;
@class GridItemModel;
@protocol GridViewDelegate <NSObject>

@optional

- (void)grideView:(GridView *)gridView selectItemAtIndex:(NSInteger)index;
- (void)grideViewmoreItemButtonClicked:(GridView *)gridView;
- (void)grideViewPassDeleateValue:(GridItemModel *)model;
- (void)grideViewMoveToPassValue:(NSArray *)arr;

@end
@interface GridView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, weak) id<GridViewDelegate> gridViewDelegate;
@property (nonatomic, strong) NSArray *gridModelsArray;
@property (nonatomic, strong)NSMutableArray *itemsArray;
- (void)setupSubViewsFrame;

@end
