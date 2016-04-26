//
//  GridViewMoreButton.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "GridViewMoreButton.h"

@implementation GridViewMoreButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    GridViewListItemButton *button = [[GridViewListItemButton alloc] init];
    
    button.backgroundColor=[UIColor whiteColor];
    [self addSubview:button];
    _button = button;
    
    
}



#pragma mark - properties

- (void)setItemModel:(GridItemModel *)itemModel
{
    _itemModel = itemModel;
    
    if (itemModel.title) {
        [_button setTitle:itemModel.title forState:UIControlStateNormal];
    }
    
    if (itemModel.imageResString) {
        
        [_button setImage:[UIImage imageNamed:itemModel.imageResString] forState:UIControlStateNormal];
    }
    
}



#pragma mark -circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _button.frame = CGRectMake(0, 0, self.frame.size.width-1, self.frame.size.height-1);
    
}


@end
