
//
//  DCDownloadFootView.m
//  jsce
//
//  Created by mac on 15/9/30.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCDownloadFootView.h"

@implementation DCDownloadFootView
+ (instancetype)dcDownloadFootView{
    return [[NSBundle mainBundle] loadNibNamed:@"DCDownloadFootView" owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
