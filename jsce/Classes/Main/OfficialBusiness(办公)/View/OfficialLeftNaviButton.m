//
//  OfficialLeftNaviButton.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "OfficialLeftNaviButton.h"
#import "UIImage+Circle.h"
#import "UIView+SDExtension.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@implementation OfficialLeftNaviButton

- (instancetype)initWithFrame:(CGRect)frame andHeadPortraitStr:(NSString *)headPortraitStr{
    if (self=[super initWithFrame:frame]) {
        
        UIImage *img = [UIImage circleImageWithName:headPortraitStr borderWidth:0 borderColor:[UIColor blackColor]];
        self.headPortraitView=[[UIImageView alloc] initWithImage:img];
        
        [self addSubview:self.headPortraitView];
        
        self.nameLable= [[UILabel alloc] init];
        self.nameLable.font=[UIFont systemFontOfSize:12.0];
        self.nameLable.textColor = [UIColor whiteColor];
        self.nameLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLable];
        
        self.companyLable=[[UILabel alloc] init];
        self.companyLable.font=[UIFont systemFontOfSize:10.0];
        self.companyLable.textAlignment = NSTextAlignmentLeft;
        self.companyLable.textColor = [UIColor whiteColor];
        [self addSubview:self.companyLable];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat padding =4;
    CGFloat viewH=self.sd_height-padding*2;
    CGFloat viewW=viewH;
    CGFloat viewX = 0;
    CGFloat viewY = padding;
    
    self.headPortraitView.frame=CGRectMake(viewX, viewY, viewW, viewH);
    
    CGFloat lableW=self.sd_width-viewW;
    CGFloat lableH=viewH / 2;
    CGFloat lableX=viewW+padding;
    CGFloat lableY=padding;
    self.nameLable.frame = CGRectMake(lableX, lableY+2, lableW, lableH);
    
    self.companyLable.frame = CGRectMake(lableX, CGRectGetMaxY(self.nameLable.frame)-2, lableW, lableH);
    
}


@end
