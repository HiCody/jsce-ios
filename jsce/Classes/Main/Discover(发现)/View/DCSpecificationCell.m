//
//  DCSpecificationCell.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCSpecificationCell.h"

@implementation DCSpecificationCell

+ (instancetype)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"DCSpecificationCell" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
