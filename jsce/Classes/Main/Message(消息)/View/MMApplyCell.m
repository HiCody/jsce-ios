//
//  MMApplyCell.m
//  jsce
//
//  Created by mac on 15/10/13.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMApplyCell.h"

@implementation MMApplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:_headerImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_contentLabel];
        
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 90, 0, 80, 30)];
        [_addButton setBackgroundColor:[UIColor whiteColor]];
        [_addButton setTitle:@"同意" forState:UIControlStateNormal];
        _addButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _addButton.layer.borderWidth=0.5;
        _addButton.layer.cornerRadius=2.0;
        _addButton.clipsToBounds = YES;
        [_addButton setTitleColor:NAVBAR_COLOR forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addButton];
        
        _refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 0, 50, 30)];
        [_refuseButton setBackgroundColor:[UIColor colorWithRed:87 / 255.0 green:186 / 255.0 blue:205 / 255.0 alpha:1.0]];
        [_refuseButton setTitle:@"拒接" forState:UIControlStateNormal];
        _refuseButton.clipsToBounds = YES;
        [_refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _refuseButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_refuseButton addTarget:self action:@selector(refuseFriend) forControlEvents:UIControlEventTouchUpInside];
        _refuseButton.hidden=YES;
        [self.contentView addSubview:_refuseButton];
        
//        _bottomLineView = [[UIView alloc] init];
//        _bottomLineView.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:210 /255.0 blue:213 / 255.0 alpha:0.7];
//        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _addButton.frame = CGRectMake(self.contentView.frame.size.width - 70, (self.contentView.frame.size.height - 35) / 2, 60, 35);
    _refuseButton.frame = CGRectMake(self.contentView.frame.size.width - 120, (self.contentView.frame.size.height - 30) / 2, 50, 30);
    _bottomLineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
    if (_contentLabel.text.length > 0) {
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), 20);
        _contentLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), _titleLabel.frame.size.width, self.contentView.frame.size.height - 20 - _titleLabel.frame.size.height);
    }
    else{
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, 10, self.contentView.frame.size.width - 120 - (CGRectGetMaxX(_headerImageView.frame) + 10), self.contentView.frame.size.height - 20);
        _contentLabel.frame = CGRectZero;
    }
}

- (void)addFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellAddFriendAtIndexPath:)])
    {
        [_delegate applyCellAddFriendAtIndexPath:self.indexPath];
    }
}

- (void)refuseFriend
{
    if(_delegate && [_delegate respondsToSelector:@selector(applyCellRefuseFriendAtIndexPath:)])
    {
        [_delegate applyCellRefuseFriendAtIndexPath:self.indexPath];
    }
}

+ (CGFloat)heightWithContent:(NSString *)content
{
    if (!content || content.length == 0) {
        return 60;
    }
    else{
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(320 - 60 - 120, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        return size.height > 20 ? (size.height + 40) : 60;
    }
}


@end
