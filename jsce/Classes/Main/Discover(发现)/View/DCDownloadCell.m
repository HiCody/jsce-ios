//
//  DCDownloadCell.m
//  jsce
//
//  Created by mac on 15/9/30.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCDownloadCell.h"
#define TEXTFONT [UIFont systemFontOfSize:15.0]
@implementation DCDownloadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLable  = [[UILabel alloc] init];
        _titleLable.font =TEXTFONT;
        _titleLable.numberOfLines=0;
        _titleLable.textAlignment   = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLable];
        
        _fileSizeLable = [[UILabel alloc] init];
        _fileSizeLable.font =TEXTFONT;
        _fileSizeLable.textAlignment   = NSTextAlignmentRight;
        _fileSizeLable.textColor = [UIColor redColor];
        [self.contentView addSubview:_fileSizeLable];
        
        _progressView= [[UIProgressView alloc] init];
        [self.contentView addSubview:_progressView];
        
        _isShow = NO;
    }
    return  self;
}

- (void)setTitleStr:(NSString *)titleStr andFileSizeStr:(NSString *)fileSizeStr andIsShow:(BOOL)isShow{
    _titleStr  = titleStr;
    _fileSizeStr = fileSizeStr;
    _titleLable.text = _titleStr;
    _fileSizeLable.text=_fileSizeStr;
    _isShow = isShow;
    [self setUpViewFrame];
}

- (void)setUpViewFrame{
    CGFloat paddingX=18;
    CGFloat paddingY=13;
    
    CGSize titleSize=[self sizeWithText:_titleLable.text font:TEXTFONT maxSize:CGSizeMake(screenWidth-2*paddingX, MAXFLOAT)];
    _titleLable.frame = CGRectMake(paddingX, paddingY, titleSize.width, titleSize.height);
    
    
    CGSize fileSize=[_fileSizeLable.text textSizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:0];
    _fileSizeLable.frame=CGRectMake(screenWidth-paddingX-fileSize.width, paddingY, fileSize.width, fileSize.height);
    
    CGFloat tempheight=paddingY+titleSize.height;
    if (_isShow) {
        _progressView.frame = CGRectMake(0, tempheight+paddingY*2, screenWidth, 2);
        tempheight += 2+paddingY*2;
   
    }else{
        tempheight+=0;
        
    }
    
  self.cellHeight =paddingY+tempheight;
    
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
