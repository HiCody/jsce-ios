//
//  AddGridView.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GridItemModel;
@protocol AddGridViewDelegate<NSObject>

- (void)addItemGridViewPassAddValue:(GridItemModel *)model;

@end

@interface AddGridView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *gridModelsArray;

@property (nonatomic, copy) void (^itemClickedOperationBlock)(GridItemModel *model);

@property(nonatomic,strong)NSMutableArray *itemsArray;

@property(nonatomic,weak)id<AddGridViewDelegate>addItemDelegate;

@end
