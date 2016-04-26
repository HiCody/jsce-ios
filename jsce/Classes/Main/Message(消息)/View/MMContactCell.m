//
//  MMContactCell.m
//  jsce
//
//  Created by mac on 15/10/10.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMContactCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@implementation MMContactCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.headImageView.frame = CGRectMake(10, (self.frame.size.height-_imgHeight)/2, _imgHeight, _imgHeight);
    
    
    
    CGSize textSize=[self sizeWithText:self.nameLable.text font:self.nameLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.nameLable.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10,(self.frame.size.height-_imgHeight)/2, textSize.width, textSize.height);
    
    
    CGSize textSize2=[self sizeWithText:self.detailLable.text font:self.detailLable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.detailLable.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10, (self.frame.size.height-_imgHeight)/2+self.headImageView.frame.size.height-textSize2.height,W(220), textSize2.height);
    
    _vipImg.frame=CGRectMake(self.nameLable.frame.origin.x+self.nameLable.frame.size.width+5, self.nameLable.frame.origin.y, 14, textSize.height);
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _vipImg = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"icon_verify_20"]];
        [self.contentView addSubview:_vipImg];
        
        _isVip = NO;
        
        _headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        
        _nameLable = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLable];
        
        _detailLable =[[UILabel alloc] init];
        [self.contentView addSubview:_detailLable];
        
        _nameLable.font=[UIFont systemFontOfSize:16.0];
        _detailLable.font=[UIFont systemFontOfSize:12.0];
        _detailLable.textColor = [UIColor darkGrayColor];
        
        _imgHeight=36;
    }
    return self;
}

- (void)setIsVip:(BOOL)isVip{
    _isVip = isVip;
    if (_isVip) {
        _vipImg.hidden=NO;
    }else{
        _vipImg.hidden=YES;
    }
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
