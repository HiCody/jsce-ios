//
//  AddGridView.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "AddGridView.h"
#import "GridViewListItemView.h"
#import "UIView+SDExtension.h"
#import "GridItemModel.h"

#define kHomeGridViewPerRowItemCount 3
#define kHomeGridViewPerPaddigCount  2
@implementation AddGridView{
    
    CGPoint lastPoint;
    UIButton *placeholderButton;
    GridViewListItemView *currentPressedView;
    CGRect currentPresssViewFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.itemsArray = [[NSMutableArray alloc] init];
        placeholderButton = [[UIButton alloc] init];
        
    }
    return self;
}

#pragma mark - properties
- (void)setGridModelsArray:(NSArray *)gridModelsArray{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self.itemsArray removeAllObjects];
    
    _gridModelsArray = gridModelsArray;
    
    [gridModelsArray enumerateObjectsUsingBlock:^(GridItemModel *model, NSUInteger idx, BOOL *stop) {
        GridViewListItemView *item = [[GridViewListItemView alloc] init];
        item.itemModel = model;
        __weak typeof(self) weakSelf= self;
        item.itemLongPressedOperationBlock = ^(UILongPressGestureRecognizer *longPressed){
            [weakSelf buttonLongPressed:longPressed];
        };
        item.iconViewClickedOperationBlock = ^(GridViewListItemView *view){
            [weakSelf deleteView:view];
        };
        item.buttonClickedOperationBlock = ^(GridViewListItemView *view){
            if (!currentPressedView.hidenIcon && currentPressedView) {
                currentPressedView.hidenIcon = YES;
                return;
            }
    
        };
        
        [self addSubview:item];
        [self.itemsArray addObject:item];
        
    }];
    
}

#pragma mark - actions

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)longPressed{
    GridViewListItemView *pressedView = (GridViewListItemView *)longPressed.view;
    CGPoint point = [longPressed locationInView:self];
    
    if (longPressed.state == UIGestureRecognizerStateBegan) {
        currentPressedView.hidenIcon = YES;
        currentPressedView = pressedView;
        currentPresssViewFrame = pressedView.frame;
        
        longPressed.view.transform= CGAffineTransformMakeScale(1.1, 1.1);
        pressedView.hidenIcon = NO;
        long index = [_itemsArray indexOfObject:longPressed.view];
        [self.itemsArray removeObject:longPressed.view];
        [self.itemsArray insertObject:placeholderButton atIndex:index];
        lastPoint = point;
        [self bringSubviewToFront:longPressed.view];
        
    }
    
    
    CGRect temp = longPressed.view.frame;
    temp.origin.x += point.x - lastPoint.x;
    temp.origin.y += point.y - lastPoint.y;
    longPressed.view.frame = temp;
    
    lastPoint = point;
    
    [self.itemsArray enumerateObjectsUsingBlock:^(UIView *button, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(button.frame, point)&& button != longPressed.view) {
            [self.itemsArray removeObject:placeholderButton];
            [self.itemsArray insertObject:placeholderButton atIndex:idx];
            *stop = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                [self setupSubViewsFrame];
            }];
        }
    }];
    
    if (longPressed.state == UIGestureRecognizerStateEnded) {
        long index =[self.itemsArray indexOfObject:placeholderButton];
        [self.itemsArray removeObject:placeholderButton];
        [self.itemsArray insertObject:longPressed.view atIndex:index];
        
        [self sendSubviewToBack:longPressed.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            longPressed.view.transform =CGAffineTransformIdentity;
            [self setupSubViewsFrame];
        } completion:^(BOOL finished) {
            if (CGRectEqualToRect(currentPresssViewFrame, currentPressedView.frame)) {
                currentPressedView.hidenIcon =NO;
            }
        }];
    }
}

- (void)deleteView:(GridViewListItemView *)view
{
    if (self.addItemDelegate&&[self.addItemDelegate respondsToSelector:@selector(addItemGridViewPassAddValue:)]) {
        [self.addItemDelegate addItemGridViewPassAddValue:view.itemModel];
    }
    
    [_itemsArray removeObject:view];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
    }];

}

- (void)setupSubViewsFrame{
    CGFloat padding=0.0;
    CGFloat itemW=self.sd_width/ kHomeGridViewPerRowItemCount;
    CGFloat itemH=itemW;
    [self.itemsArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / kHomeGridViewPerRowItemCount;
        long columnIndex = idx % kHomeGridViewPerRowItemCount;
        CGFloat x =(itemW+padding)*columnIndex;
        CGFloat y= (itemH+padding) * rowIndex;
        
        item.frame = CGRectMake(x, y, itemW, itemH);
        
        if (idx == (self.itemsArray.count - 1)) {
            self.contentSize = CGSizeMake(0, item.sd_height + item.sd_y);
        }
        
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubViewsFrame];
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    currentPressedView.hidenIcon = YES;
}


@end




