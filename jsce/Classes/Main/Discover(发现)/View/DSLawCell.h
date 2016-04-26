
//
//  DSLawCell.h
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSLawCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titileLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

/**
 *  查阅数
 */
@property (weak, nonatomic) IBOutlet UILabel *checkCountLable;

/**
 *  发布时间
 */
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLable;

/**
 *  对应地点
 */
@property (weak, nonatomic) IBOutlet UILabel *cityLable;


+ (instancetype)cell;
@end
