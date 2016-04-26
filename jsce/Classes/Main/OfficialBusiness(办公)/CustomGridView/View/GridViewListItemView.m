//
//  GridViewListItemView.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "GridViewListItemView.h"
#import "UIView+SDExtension.h"
#import "GridViewListItemButton.h"
@implementation GridViewListItemView
{
    GridViewListItemButton *_button;
    UIButton *_iconView;
}

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
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor whiteColor];
    [self addSubview:button];
    _button = button;
    
    UIButton *icon = [[UIButton alloc] init];
    [icon setImage:[UIImage imageNamed:@"GridView_delete_icon"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(iconViewClicked) forControlEvents:UIControlEventTouchUpInside];
    icon.hidden = YES;
    [self addSubview:icon];
    _iconView = icon;
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressed:)];
    [self addGestureRecognizer:longPressed];
}

#pragma mark - actions

- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    if (self.itemLongPressedOperationBlock) {
        self.itemLongPressedOperationBlock(longPressed);
    }
}

- (void)buttonClicked
{
    if (self.buttonClickedOperationBlock) {
        self.buttonClickedOperationBlock(self);
    }
}

- (void)iconViewClicked
{
    if (self.iconViewClickedOperationBlock) {
        self.iconViewClickedOperationBlock(self);
    }
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

- (void)setHidenIcon:(BOOL)hidenIcon
{
    _hidenIcon = hidenIcon;
    _iconView.hidden = hidenIcon;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    
    [_iconView setImage:iconImage forState:UIControlStateNormal];
}

#pragma mark -circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //CGFloat margin = 10;
    _button.frame = CGRectMake(0, 0, self.frame.size.width-1, self.frame.size.height-1);
    _iconView.frame = CGRectMake(self.sd_width - _iconView.sd_width, 0, 30, 30);
}


@end
