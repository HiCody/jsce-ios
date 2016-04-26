//
//  FilterFirstColumnCell.m
//  Filter
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "FilterFirstColumnCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define TextFont [UIFont systemFontOfSize:15]
@implementation FilterFirstColumnCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _contentLabel=[[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font=TextFont;
        _contentLabel.numberOfLines=0;//换行
        [self.contentView addSubview:_contentLabel];
    }
    return  self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
     _contentLabel.text=title;
    
    [self setUpFrame];
}

- (void)setUpFrame{
    CGSize contentSize=[self sizeWithText:_title font:TextFont maxSize:CGSizeMake(150-W(10)-25, MAXFLOAT)];
    if (contentSize.height<30) {
        contentSize.height=30;
    }
    _contentLabel.frame=CGRectMake(25, 10,contentSize.width, contentSize.height);
     _cellHeight=CGRectGetMaxY(_contentLabel.frame)+10;
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
