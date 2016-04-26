//
//  UIImage+Name.m
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "UIImage+Name.h"

@implementation UIImage (Name)

+ (UIImage *) imageWithView:(NSString *)str
{
    
    NSArray *arr =  @[RGB(224, 107, 120),RGB(127, 203, 51),
                      RGB(255, 148, 61),RGB(60, 192, 241)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    lable.font =[UIFont boldSystemFontOfSize:27.0];
    lable.text = str;
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment =NSTextAlignmentCenter;
    

    lable.backgroundColor =arr[arc4random()%4];
    
    UIGraphicsBeginImageContextWithOptions(lable.bounds.size, lable.opaque, [[UIScreen mainScreen] scale]);
    
    [lable.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
