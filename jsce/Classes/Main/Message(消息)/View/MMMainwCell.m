//
//  MMMainwCell.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMMainwCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
@implementation MMMainwCell


- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imgView];
        
        self.arrowIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        self.arrowIndicator.hidden = YES;
        [self.contentView addSubview:self.arrowIndicator];
        
        self.titileLable = [[UILabel alloc] init];
        self.titileLable.hidden=YES;
        self.titileLable.textAlignment = NSTextAlignmentLeft;
        self.titileLable.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titileLable];
        
        self.detailLable = [[UILabel alloc] init];
        self.detailLable.hidden=YES;
        self.detailLable.textAlignment = NSTextAlignmentLeft;
        self.detailLable.font = [UIFont systemFontOfSize:15.0];
        self.detailLable.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.detailLable];
        
        self.dateLable = [[UILabel alloc] init];
        self.dateLable.hidden=YES;
        self.dateLable.font = [UIFont systemFontOfSize:13.0];
        self.dateLable.textColor = [UIColor lightGrayColor];
        self.dateLable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLable];
        
        self.middleTitleLable  = [[UILabel alloc] init];
        self.middleTitleLable.hidden=YES;
        self.middleTitleLable.textAlignment = NSTextAlignmentLeft;
        self.middleTitleLable.font = [UIFont systemFontOfSize:17.0];
        [self.contentView addSubview:self.middleTitleLable];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size =self.frame.size;
    self.imgView.frame = CGRectMake(10, (self.frame.size.height-44)/2, 44, 44);

    CGSize textSize1=[self sizeWithText:self.middleTitleLable.text font:self.middleTitleLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.middleTitleLable.frame = CGRectMake(62, (size.height-textSize1.height)/2.0, W(200), textSize1.height);
    
    CGSize textSize2=[self sizeWithText:self.titileLable.text font:self.titileLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.titileLable.frame = CGRectMake(62, self.imgView.frame.origin.y, W(200), textSize2.height);
    
    CGSize textSize3=[self sizeWithText:self.detailLable.text font:self.detailLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.detailLable.frame = CGRectMake(62, CGRectGetMaxY(self.imgView.frame)-textSize3.height, W(200), textSize3.height);
    
    CGSize textSize4=[self sizeWithText:self.dateLable.text font:self.dateLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.dateLable.frame = CGRectMake(size.width-10, self.imgView.frame.origin.y, W(100), textSize4.height);
    
    self.arrowIndicator.frame= CGRectMake(size.width-30, (size.height-20)/2.0, 20, 20);
    
    
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
