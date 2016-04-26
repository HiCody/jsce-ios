//
//  FilterHeardView.m
//  jsce
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "FilterHeardView.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2

#define TEXTFONT [UIFont systemFontOfSize:14.0]

@implementation FilterHeardView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        _titleLable=[[UILabel alloc] init];
        _titleLable.textAlignment =NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:14.0];
        _titleLable.textColor =[UIColor blackColor];
         [self addSubview:_titleLable];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.backgroundColor=[UIColor clearColor];
        self.index=0;
        self.selectedIndex=-1;
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setBtnTitleWithArr:(NSArray *)titleArr{
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor=[UIColor whiteColor];
    
        btn.layer.borderWidth=1.0;
        btn.layer.cornerRadius=4.0;
        btn.layer.borderColor=NAVBAR_COLOR.CGColor;
        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:NAVBAR_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [btn setBackgroundImage:[self setImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[self setImageWithColor:NAVBAR_COLOR] forState:UIControlStateSelected];
        btn.titleLabel.font=TEXTFONT;
        
        [btn addTarget:self action:@selector(passSelectedBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:btn];
    }
}

-(void)passSelectedBtn:(UIButton *)btn{
    if (btn.selected) {
        self.selectedIndex=btn.tag-100;
        return ;
    }else{
        btn.selected=YES;
        btn.backgroundColor = NAVBAR_COLOR;
        if (self.index) {
            UIButton *lastBtn =(UIButton *)[self.scrollView viewWithTag:self.index];
            lastBtn.selected=!lastBtn.selected;
            lastBtn.backgroundColor = [UIColor whiteColor];
           
        }
        self.selectedIndex=btn.tag-100;
        self.index = btn.tag;
    }
}

- (void)reloadData{

    if (self.index) {
        UIButton *lastBtn =(UIButton *)[self.scrollView viewWithTag:self.index];
        lastBtn.selected=!lastBtn.selected;
        lastBtn.backgroundColor = [UIColor whiteColor];
        
    }
    self.index= 0;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width =self.frame.size.width;
    CGFloat height= self.frame.size.height;
    
    CGSize lableSize = [self sizeWithText:_titleLable.text font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _titleLable.frame =CGRectMake(10, 0,lableSize.width, height);
    
    _scrollView.frame=CGRectMake(10+lableSize.width+10, 0,width-10-lableSize.width-10, height);
    
    CGFloat padding =W(15);
    CGFloat padding2=5;
    NSInteger count=self.scrollView.subviews.count;
    CGFloat btnX=0;
    CGFloat contentSizeWidth=0;
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i =0; i<count; i++) {
         if ([self.scrollView.subviews[i] isMemberOfClass:[UIButton class]]) {
             [arr addObject:self.scrollView.subviews[i]];
         }
    }
    
    
    for (int i=0; i<arr.count; i++) {
        UIButton *tmpBtn=arr[i];
        tmpBtn.tag=i+100;
        
        NSString *str=tmpBtn.titleLabel.text;
        
        CGSize btnSize = [self sizeWithText:str font:TEXTFONT maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        
        
        CGFloat btnWidth=btnSize.width+2*padding2;
        CGFloat btnHeight=30;
        CGFloat btnY=(self.scrollView.frame.size.height-btnHeight)/2.0;
        btnX=contentSizeWidth+padding;
        
        tmpBtn.frame=CGRectMake(btnX, btnY, btnWidth, btnHeight);

        contentSizeWidth+=padding+btnWidth;
    }
    
    self.scrollView.contentSize = CGSizeMake(contentSizeWidth, _scrollView.frame.size.height);
}


//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (UIImage *)setImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 300, 300);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imge;
}

@end
