//
//  ICPersonalInfoHeaderView.m
//  jsce
//
//  Created by mac on 15/9/24.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICPersonalInfoHeaderView.h"

@implementation ICPersonalInfoHeaderView
+ (instancetype)iCPersonalInfoHeaderView{
    return [[NSBundle mainBundle] loadNibNamed:@"ICPersonalInfoHeaderView" owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
