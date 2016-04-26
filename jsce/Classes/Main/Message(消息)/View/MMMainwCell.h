//
//  MMMainwCell.h
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMainwCell : UITableViewCell
@property (strong, nonatomic)UIImageView *imgView;

/**
 *  上面的lable
 */
@property (strong, nonatomic)  UILabel *titileLable;
@property (strong, nonatomic)  UILabel *detailLable;
@property (strong, nonatomic)  UILabel *dateLable;
@property (strong, nonatomic)  UIImageView *arrowIndicator;

/**
 *  单一显示时的lable
 */
@property (strong, nonatomic)  UILabel *middleTitleLable;


@end
