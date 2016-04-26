//
//  DCToolBar.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCToolBar.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@interface DCButton : UIButton

@end

@implementation DCButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:4/255.0 green:169/255.0 blue:244/255.0 alpha:1.0]  forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.sd_height * 0.5;
    CGFloat w = h;
    CGFloat x = (self.sd_width - w) * 0.5;
    CGFloat y = self.sd_height * 0.1;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.sd_height * 0.6, self.sd_width, self.sd_height * 0.3);
}


@end


@implementation DCToolBar

- (void)addTabButtonWithImgName:(NSString *)name andImaSelName:(NSString *)selName andTitle:(NSString *)title{
    DCButton *btn=[[DCButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn  setImage:[UIImage imageNamed:selName] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    if (self.subviews.count==1) {
//        [self  buttonClick:btn];
//    }
}

- (void)buttonClick:(id)sender{
    UIButton *btn=sender;
    btn.selected=YES;
    self.selectBtn.selected=NO;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willSelectIndex:)]) {
        [self.delegate willSelectIndex:btn.tag-100];
    }
    self.selectBtn=btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count=self.subviews.count;
    for (int i=0; i<count; i++) {
        UIButton *tmpBtn=self.subviews[i];
        tmpBtn.tag=i+100;
        
        CGFloat btnY=0;
        CGFloat btnWidth=WinWidth/count;
        CGFloat btnHeight=self.frame.size.height;
        CGFloat btnX=i*btnWidth;
        
        tmpBtn.frame=CGRectMake(btnX, btnY, btnWidth, btnHeight);
    }
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//    
//    }
//    return  self;
//}

@end
