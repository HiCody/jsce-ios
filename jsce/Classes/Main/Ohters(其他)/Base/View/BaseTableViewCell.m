//
//  BaseTableViewCell.m
//  jsce
//
//  Created by mac on 15/10/10.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "BaseTableViewCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.headImgView.frame = CGRectMake(10, (self.frame.size.height-34)/2, 34, 34);
    
    CGRect rect = self.textLabel.frame;
    
    CGSize textSize=[self sizeWithText:self.textLabel.text font:self.textLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    rect.origin.x = CGRectGetMaxX(self.headImgView.frame) + 10;
    
    if (textSize.width>W(200)) {
        textSize.width = W(200);
    }
    
    rect.size.width=textSize.width;
    self.textLabel.frame = rect;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
  
        _headImgView  = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        _titleLable = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLable];

    }
    return self;
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
