//
//  MMChatTimeCell.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatTimeCell.h"

@implementation MMChatTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
