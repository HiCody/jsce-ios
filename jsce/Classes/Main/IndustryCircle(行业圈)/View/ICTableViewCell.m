//
//  ICTableViewCell.m
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICTableViewCell.h"
#import "ICReplyBody.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2

@implementation ICTableViewCell{
    UIButton *foldBtn;
    UIImageView *replyImageView;
    
    CGPoint arrowPoint;
    CGPoint arrowPoint2;
    CGPoint arrowPoint3;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        arrowPoint=CGPointZero;
        arrowPoint2=CGPointZero;
        arrowPoint3=CGPointZero;
        
        _userHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, TableHeader)];
        _userHeaderImage.backgroundColor = [UIColor clearColor];
        CALayer *layer = [_userHeaderImage layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2.0];
        [self.contentView addSubview:_userHeaderImage];
        
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 10, 10, screenWidth - 120, TableHeader/2)];
        _userNameLbl.textAlignment = NSTextAlignmentLeft;
        _userNameLbl.font = [UIFont boldSystemFontOfSize:16.0];
        _userNameLbl.textColor = TEXTCOLOR;
        [self.contentView addSubview:_userNameLbl];
        
        _isVip =NO;
        _vipImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vipImage.image =[UIImage imageNamed:@"icon_verify_20"];
        _vipImage.hidden =YES;
        [self.contentView addSubview:_vipImage];
        
        
        _userCompanyLbl = [[UILabel alloc] initWithFrame:CGRectMake(20 + TableHeader + 10, 10 + TableHeader/2 , screenWidth - 120, TableHeader/2)];
        _userCompanyLbl.numberOfLines = 1;
        _userCompanyLbl.font = [UIFont systemFontOfSize:14.0];
        _userCompanyLbl.textColor = [UIColor hexFloatColor:@"999e9f"];
        [self.contentView addSubview:_userCompanyLbl];
        
        _commitTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-120-20, 10, 120, TableHeader/2)];
        _commitTimeLbl.numberOfLines = 1;
        _commitTimeLbl.font          = [UIFont systemFontOfSize:14.0];
        _commitTimeLbl.textColor     = [UIColor hexFloatColor:@"999e9f"];
        _commitTimeLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_commitTimeLbl];

        _locationImage=[[UIImageView alloc] init];
        _locationImage.image=[UIImage imageNamed:@"location_small"];
        [self.contentView addSubview:_locationImage];

        _locationLbl=[[UILabel alloc] init];
        _locationLbl.font=[UIFont systemFontOfSize:13];
        _locationLbl.textAlignment = NSTextAlignmentLeft;
        _locationLbl.textColor=[UIColor grayColor];
        [self.contentView addSubview:_locationLbl];

        
        
        _imageArray = [[NSMutableArray alloc] init];
        _icTextArray = [[NSMutableArray alloc] init];
        _icShuoshuoArray = [[NSMutableArray alloc] init];
        _icFavourArray = [[NSMutableArray alloc] init];
        
        foldBtn = [UIButton buttonWithType:0];
        [foldBtn setTitle:@"全文" forState:0];
        foldBtn.backgroundColor = [UIColor clearColor];
        foldBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [foldBtn setTitleColor:TEXTCOLOR forState:0];
        [foldBtn addTarget:self action:@selector(foldText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foldBtn];
      
        replyImageView = [[UIImageView alloc] init];
        
        replyImageView.backgroundColor = kReplyBackGround;
        [self.contentView addSubview:replyImageView];
        
        _replyBtn = [[ICButton alloc ] initWithFrame:CGRectZero];
        [self.contentView addSubview:_replyBtn];
        
        _favourBtn = [[ICButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_favourBtn];
        
        _favourImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _favourImage.image = [UIImage imageNamed:@"my_collection_collect"];
        [self.contentView addSubview:_favourImage];
        
        _replyImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _replyImage.image = [UIImage imageNamed:@"tw_fy_normal"];
        [self.contentView addSubview:_replyImage];
    }
    return self;
}

#pragma mark -显示全文或收起
- (void)foldText{
    
    if (self.icTextData.foldOrNot == YES) {
        self.icTextData.foldOrNot = NO;
        [foldBtn setTitle:@"收起" forState:0];
    }else{
        self.icTextData.foldOrNot = YES;
        [foldBtn setTitle:@"全文" forState:0];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(changeFoldState:onCellRow:)]) {
        [_delegate changeFoldState:self.icTextData onCellRow:self.stamp];
        
    }
   
}

- (void)setIcTextData:(ICTextData *)icTextData{
    _icTextData  = icTextData;
    UIImage *placeHolder=[UIImage imageNamed:@"timeline_image_loading"];
    CGFloat cellheight=0;
    
#pragma mark -  //头像 昵称 简介
    
    NSURL *userUrl = [NSURL URLWithString:_icTextData.messageBody.posterImgstr];
    [_userHeaderImage sd_setImageWithURL:userUrl placeholderImage:placeHolder];
    _userHeaderImage.userInteractionEnabled=YES;
    UITapGestureRecognizer  *userHeaderTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segueToICPersonalInfoVC:)];
    userHeaderTap.numberOfTapsRequired=1;
    [_userHeaderImage addGestureRecognizer:userHeaderTap];
    
    
    _userNameLbl.text = _icTextData.messageBody.posterName;
    _userCompanyLbl.text = _icTextData.messageBody.post;
    _commitTimeLbl.text = _icTextData.messageBody.releaseTime;
 
#pragma mark - vip标志的位置
    _isVip = _icTextData.messageBody.isVip;
    CGSize nameSize =[_userNameLbl.text textSizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _vipImage.frame =CGRectMake(nameSize.width+20 + TableHeader + 10+8, 10+(TableHeader/2-15)/2, 12, 15);
    if (_isVip) {
        self.vipImage.hidden =NO;
    }else{
        self.vipImage.hidden =YES;
    }
  
     //移除说说view 避免滚动时内容重叠
    for (int i =0; i<_icShuoshuoArray.count; i++) {
        ICTextView *icTextView=(ICTextView *)[_icShuoshuoArray objectAtIndex:i];
        if (icTextView.superview) {
            [icTextView removeFromSuperview];
        }
    }
    
    [_icShuoshuoArray removeAllObjects];
    
    cellheight=10+TableHeader;
    
#pragma mark - 添加说说view
    ICTextView *textView = [[ICTextView alloc] initWithFrame:CGRectMake(offSet_X, 20 + TableHeader, screenWidth - 2 * offSet_X, 0)];
    textView.delegate = self;
    textView.attributedData = _icTextData.attributedDataShuoshuo;
    textView.isFold = _icTextData.foldOrNot;
    textView.isDraw = YES;
    [textView setOldString:_icTextData.showShuoShuo andNewString:_icTextData.completionShuoshuo];
    [self.contentView addSubview:textView];
    
    BOOL foldOrnot = _icTextData.foldOrNot;
    float hhhh = foldOrnot?_icTextData.shuoshuoHeight:_icTextData.unFoldShuoHeight;
    
    textView.frame = CGRectMake(offSet_X, cellheight+kShuoshuoDistance, screenWidth - 2 * offSet_X, hhhh);
    
    [_icShuoshuoArray addObject:textView];
    
    cellheight+=hhhh+kShuoshuoDistance;
    
#pragma mark 按钮 foldBtn

    if (_icTextData.islessLimit) {//小于最小限制 隐藏折叠展开按钮
        foldBtn.frame=CGRectZero;
        foldBtn.hidden = YES;
        cellheight+= 0;
    }else{
        foldBtn.frame = CGRectMake(offSet_X - 10, cellheight + kFoldBtnDistance , 50, 20 );
        foldBtn.hidden = NO;
        cellheight+= kFoldBtnDistance+ 20;
    }
    
    
    if (_icTextData.foldOrNot == YES) {
        
        [foldBtn setTitle:@"全文" forState:0];
    }else{
        
        [foldBtn setTitle:@"收起" forState:0];
    }

#pragma mark - 图片部分
    
    for (int i = 0; i < [_imageArray count]; i++) {
        
        UIImageView * imageV = (UIImageView *)[_imageArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
     [_imageArray removeAllObjects];
    
    for (int i=0; i<_icTextData.showImageArray.count; i++) {
        int row   = i / 3; //行
        int column= i % 3; //列
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(offSet_X+(ShowImage_H+10)*column,cellheight+kImageDistance+row*(ShowImage_H+10), ShowImage_H, ShowImage_H)];
        image.layer.borderWidth=1.0;
        image.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [image sd_setImageWithURL:[NSURL URLWithString:[icTextData.showImageArray objectAtIndex:i]] placeholderImage:placeHolder];
        image.tag =100+i;
        image.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [image addGestureRecognizer:tap];
        
        // 内容模式
        image.clipsToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;

        [self.contentView addSubview:image];
        [_imageArray addObject:image];
    }
    
#pragma mark - 地理位置
    
    float origin_Y = 10;
    NSUInteger scale_Y = _icTextData.showImageArray.count - 1;

    if (_icTextData.showImageArray.count == 0) {
        cellheight+=0;
    }else{
        cellheight+=kImageDistance+(ShowImage_H+10)*(scale_Y/3)+ShowImage_H;
    }
    
    _locationImage.frame=CGRectMake(offSet_X+3, cellheight+kLocationDistance, 14, 18);
    _locationLbl.text=_icTextData.messageBody.locationStr;
    _locationLbl.frame=CGRectMake(offSet_X+3+14+3,cellheight+kLocationDistance, 240, 18);

    cellheight+=kLocationDistance+18;

#pragma mark - 评论和收藏按钮
    
    _replyBtn.frame = CGRectMake(screenWidth-50-offSet_X, cellheight, 80, 30);
    [_replyBtn setImage:[UIImage imageNamed:@"tw_fy_normal"] forState:0];
    [_replyBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    _favourBtn.frame = CGRectMake(screenWidth-50-offSet_X-60, cellheight, 80, 30);
    if (_icTextData.messageBody.isFavour) {
        [_favourBtn setImage:[UIImage imageNamed:@"my_collection_y"] forState:UIControlStateNormal];
    }else{
        [_favourBtn setImage:[UIImage imageNamed:@"my_collection_collect"] forState:UIControlStateNormal];
    }
    [_favourBtn setTitle:[NSString stringWithFormat:@"%li", _icTextData.favourArray.count] forState:UIControlStateNormal];
    
    
    cellheight+=30;
    
    arrowPoint = CGPointMake(screenWidth-50/2.0-offSet_X, cellheight+4);
    
#pragma mark - 收藏部分
    
    //移除点赞view 避免滚动时内容重叠
    for ( int i = 0; i < _icFavourArray.count; i ++) {
        ICTextView * imageV = (ICTextView *)[_icFavourArray objectAtIndex:i];
        if (imageV.superview) {
            [imageV removeFromSuperview];
            
        }
    }
    
    [_icFavourArray removeAllObjects];
    
    float backView_Y = 0;
    float backView_H = 0;
    
    
    ICTextView *favorView =[[ICTextView alloc] initWithFrame:CGRectMake(offSet_X+20,cellheight+kReplyBtnDistance, screenWidth - 2 * offSet_X - 30, 0)];

    favorView.fontInteger=1;
    favorView.attributedData  = _icTextData.attributedDataFavour;
    favorView.isDraw = YES;
    favorView.isFold = NO;
    
    favorView.canClickAll = NO;
    favorView.textColor = TEXTCOLOR;
    [favorView setOldString:_icTextData.showFavour andNewString:_icTextData.completionFavour];
    favorView.frame = CGRectMake(offSet_X + 20,cellheight+kReplyBtnDistance, screenWidth - offSet_X * 2 - 30, _icTextData.favourHeight);
    [self.contentView addSubview:favorView];
    
    [_icFavourArray addObject:favorView];
    
    //收藏图片的位置
    _favourImage.frame = CGRectMake(offSet_X, favorView.frame.origin.y+3, (_icTextData.favourHeight == 0)?0:15,(_icTextData.favourHeight == 0)?0:15);
    
    backView_Y = cellheight+kReplyBtnDistance;
    
    cellheight+=_icTextData.favourHeight+kReplyBtnDistance;
    backView_H+=_icTextData.favourHeight;
#pragma mark - 最下方回复部分
    for (int i = 0; i < [_icTextArray count]; i++) {
        
        ICTextView * icTextView = (ICTextView *)[_icTextArray objectAtIndex:i];
        if (icTextView.superview) {
            [icTextView removeFromSuperview];
            
        }
    }
    
    [_icTextArray removeAllObjects];
    
    origin_Y=0;
    
    for (int i=0; i<_icTextData.replyDataSource.count; i++) {
        ICTextView *_ilcoreText = [[ICTextView alloc] initWithFrame:CGRectMake(offSet_X+20,cellheight, screenWidth - offSet_X * 2-30, 0)];
        _ilcoreText.fontInteger=1;
        if (i == 0) {
  //回复图片的位置
            _replyImage.frame = CGRectMake(offSet_X, CGRectGetMaxY(_ilcoreText.frame)+4, 15, 15);
        }
        
        _ilcoreText.delegate = self;
        _ilcoreText.replyIndex = i;
        _ilcoreText.isFold = NO;
        _ilcoreText.attributedData = [_icTextData.attributedDataReply objectAtIndex:i];
        
        ICReplyBody *body = (ICReplyBody *)[_icTextData.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        
        [_ilcoreText setOldString:matchString andNewString:[_icTextData.completionReplySource objectAtIndex:i]];
        
        _ilcoreText.frame = CGRectMake(offSet_X+20,cellheight+origin_Y, screenWidth - offSet_X * 2-30, [_ilcoreText getTextHeight]);
        [self.contentView addSubview:_ilcoreText];
        
        origin_Y += [_ilcoreText getTextHeight]  ;
        
        backView_H +=[_ilcoreText getTextHeight] ;
        
        [_icTextArray addObject:_ilcoreText];
        
    }
    
    if (_icTextData.favourArray.count==0&&_icTextData.replyDataSource.count==0) {
       
        replyImageView.frame =CGRectZero;
    }else{
        arrowPoint2=CGPointMake(arrowPoint.x-8, backView_Y-5);
        arrowPoint3=CGPointMake(arrowPoint.x+8, backView_Y-5);
        
        replyImageView.frame =CGRectMake(15, backView_Y-5, screenWidth-2*15, backView_H+5);
    }
    [self setNeedsDisplay];

    
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)drawRect:(CGRect)rect
{
    if (self.icTextData.favourArray.count||self.icTextData.replyDataSource.count) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIBezierPath *arrow = [[UIBezierPath alloc] init];
        
        CGPoint starP=arrowPoint;
        [arrow moveToPoint:starP];
        [arrow addLineToPoint:arrowPoint2];
        [arrow addLineToPoint:arrowPoint3];
        [arrow closePath];
        
        CGContextAddPath(ctx, arrow.CGPath);
        
        [kReplyBackGround setFill];
        
        CGContextFillPath(ctx);
    }

}

//点击图片集后呈现
- (void)tapImageView:(UITapGestureRecognizer *)gesture{
   
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showImageViewWithImageViews:andImageArray:byClickWhich:)]) {
            [self.delegate showImageViewWithImageViews:self.imageArray andImageArray:self.icTextData.showImageArray byClickWhich:gesture.view.tag];
    }

}

//点击头像跳转到详细页面
- (void)segueToICPersonalInfoVC:(UITapGestureRecognizer *)gesture{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(segueToPersonalInfoWith:)]) {
        [self.delegate segueToPersonalInfoWith:self.icTextData];
    }
}

@end
