//
//  MultiSelectTableViewCell.m
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MultiSelectTableViewCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

@implementation MultiSelectTableViewCell

- (void)awakeFromNib
{
    // Initialization code
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectState:(MultiSelectTableViewSelectState)selectState
{
    _selectState = selectState;
    
    switch (selectState) {
        case MultiSelectTableViewSelectStateNoSelected:
            self.selectImageView.image = [UIImage imageNamed:@"CellNotSelected"];
            break;
        case MultiSelectTableViewSelectStateSelected:
            self.selectImageView.image = [UIImage imageNamed:@"CellBlueSelected"];
            break;
        case MultiSelectTableViewSelectStateDisabled:
            self.selectImageView.image = [UIImage imageNamed:@"CellGraySelected"];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
     self.selectImageView.frame = CGRectMake(10, (self.frame.size.height-30)/2, 30, 30);
    
    self.headImageView.frame = CGRectMake(CGRectGetMaxX(self.selectImageView.frame)+12, (self.frame.size.height-_imgHeight)/2, _imgHeight, _imgHeight);
    
    
    
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
        
        _selectImageView = [[UIImageView alloc] init];
        self.selectImageView.image = [UIImage imageNamed:@"CellNotSelected"];
        [self.contentView addSubview:_selectImageView];
        
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
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
