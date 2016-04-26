//
//  ICButton.m
//  jsce
//
//  Created by mac on 15/9/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICButton.h"

@implementation ICButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.sd_height/2;
    CGFloat w = h;
    CGFloat x = (self.sd_width - w) * 0.5;
    CGFloat y = (self.sd_height-h) * 0.5;
    return CGRectMake(4, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.sd_height/2+10, 0, self.sd_width- self.sd_height, self.sd_height);
}
@end
