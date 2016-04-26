//
//  XHPopMenuItemView.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-6-7.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPopMenuItemView.h"

@interface XHPopMenuItemView ()

@property (nonatomic, strong) UIView *menuSelectedBackgroundView;

@property (nonatomic, strong) UIImageView *separatorLineImageView;

@end

@implementation XHPopMenuItemView

- (void)setupPopMenuItem:(XHPopMenuItem *)popMenuItem atIndexPath:(NSIndexPath *)indexPath isBottom:(BOOL)isBottom {
    self.popMenuItem = popMenuItem;
    self.textLabel.text = popMenuItem.title;
    self.imageView.image = popMenuItem.image;
    self.separatorLineImageView.hidden = isBottom;
}

#pragma mark - Propertys

- (UIView *)menuSelectedBackgroundView {
    if (!_menuSelectedBackgroundView) {
        _menuSelectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _menuSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _menuSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:0.9];
    }
    return _menuSelectedBackgroundView;
}

- (UIImageView *)separatorLineImageView {
    if (!_separatorLineImageView) {
        _separatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kXHMenuItemViewHeight - kXHSeparatorLineImageViewHeight, kXHMenuTableViewWidth , kXHSeparatorLineImageViewHeight)];
        _separatorLineImageView.backgroundColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:0.9];
    }
    return _separatorLineImageView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor=[UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        
        self.backgroundView = self.menuSelectedBackgroundView;
        [self.contentView addSubview:self.separatorLineImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.textLabel.frame = textLabelFrame;
}

@end
