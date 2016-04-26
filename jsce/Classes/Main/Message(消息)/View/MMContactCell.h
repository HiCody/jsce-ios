//
//  MMContactCell.h
//  jsce
//
//  Created by mac on 15/10/10.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMContactCell : UITableViewCell

@property(nonatomic,assign)BOOL  isVip;

@property(nonatomic,strong)UIImageView *vipImg;

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UILabel *nameLable;

@property(nonatomic,strong)UILabel *detailLable;

@property(nonatomic,assign)CGFloat imgHeight;
@end
