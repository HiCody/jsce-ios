//
//  DCSpecificationCell.h
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSpecificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *checkCountLable;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *fileLable;


+ (instancetype)cell;
@end
