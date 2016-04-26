//
//  MultiSelectTableViewCell.h
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MultiSelectTableViewSelectState) {
    MultiSelectTableViewSelectStateNoSelected = 0,
    MultiSelectTableViewSelectStateSelected,
    MultiSelectTableViewSelectStateDisabled,
};


@interface MultiSelectTableViewCell : UITableViewCell

@property(nonatomic,assign)BOOL  isVip;

@property(nonatomic,strong)UIImageView *vipImg;

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UILabel *nameLable;

@property(nonatomic,strong)UILabel *detailLable;

@property(nonatomic,assign)CGFloat imgHeight;

@property (strong, nonatomic)  UIImageView *selectImageView;

@property (nonatomic, assign) MultiSelectTableViewSelectState selectState;



@end
