//
//  ICHeadView.m
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICHeadView.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@implementation ICHeadView
+ (instancetype)ICHeadView{
    return [[NSBundle mainBundle] loadNibNamed:@"ICHeadView" owner:nil options:nil].lastObject;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *line = [[UIBezierPath alloc] init];
    
    CGPoint starP=CGPointMake(0, self.frame.size.height-0.5);
    [line moveToPoint:starP];
    [line addLineToPoint:CGPointMake(self.frame.size.width,  self.frame.size.height-0.5)];
    CGContextAddPath(ctx, line.CGPath);
    [kReplyBackGround setFill];
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(ctx, 0.1);
     CGContextDrawPath(ctx, kCGPathFillStroke);;
}


@end
