//
//  ICPreferenceView.m
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICPreferenceView.h"

@implementation ICPreferenceView
+ (instancetype)ICPreferenceView{
    return [[NSBundle mainBundle] loadNibNamed:@"ICPreferenceView" owner:nil options:nil].lastObject;
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
