//
//  GroupHeaderCollectionViewCell.m
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "GroupHeaderCollectionViewCell.h"

@implementation GroupHeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius=5.0;
        
        [self.contentView addSubview:_headImageView];
        
        _nameLable  =  [[UILabel alloc]  init];
        _nameLable.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_nameLable];
        
    }
    return self;
}


@end
