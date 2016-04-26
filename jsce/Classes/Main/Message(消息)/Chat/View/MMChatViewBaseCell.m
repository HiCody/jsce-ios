//
//  MMCharViewBaseCell.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatViewBaseCell.h"

NSString *const kRouterEventChatHeadImageTapEventName = @"kRouterEventChatHeadImageTapEventName";

@implementation MMChatViewBaseCell

- (id)initWithMessageModel:(MMMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImagePressed:)];
        CGFloat originX = HEAD_PADDING*2;
        if (model.isSender) {
            originX = self.bounds.size.width - HEAD_SIZE - HEAD_PADDING*2;
        }
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, CELLPADDING, HEAD_SIZE, HEAD_SIZE)];
        [_headImageView addGestureRecognizer:tap];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.multipleTouchEnabled = YES;
        _headImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
        
        [self setupSubviewsForMessageModel:model];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = _headImageView.frame;
    frame.origin.x = _messageModel.isSender ? (self.bounds.size.width - _headImageView.frame.size.width - HEAD_PADDING*2) : HEAD_PADDING*2;
    _headImageView.frame = frame;
    
    [_nameLabel sizeToFit];
    frame = _nameLabel.frame;
    frame.origin.x = HEAD_PADDING * 3 + CGRectGetWidth(_headImageView.frame) + NAME_LABEL_PADDING;
    frame.origin.y = CGRectGetMinY(_headImageView.frame);
    frame.size.width = NAME_LABEL_WIDTH;
    _nameLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - setter

- (void)setMessageModel:(MMMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _nameLabel.hidden = (messageModel.messageType == eMessageTypeChat);
    
//    UIImage *placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
//    [self.headImageView sd_setImageWithURL:_messageModel.headImageURL placeholderImage:placeholderImage];
}

#pragma mark - private

-(void)headImagePressed:(id)sender
{
    [super routerEventWithName:kRouterEventChatHeadImageTapEventName userInfo:@{KMESSAGEKEY:self.messageModel}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [super routerEventWithName:eventName userInfo:userInfo];
}

#pragma mark - public

- (void)setupSubviewsForMessageModel:(MMMessageModel *)model
{
    if (model.isSender) {
        self.headImageView.frame = CGRectMake(self.bounds.size.width - HEAD_SIZE - HEAD_PADDING, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
    }
    else{
        self.headImageView.frame = CGRectMake(0, CELLPADDING, HEAD_SIZE, HEAD_SIZE);
    }
}

+ (NSString *)cellIdentifierForMessageModel:(MMMessageModel *)model
{
    NSString *identifier = @"MessageCell";
    if (model.isSender) {
        identifier = [identifier stringByAppendingString:@"Sender"];
    }
    else{
        identifier = [identifier stringByAppendingString:@"Receiver"];
    }
    
    switch (model.type) {
        case eMessageBodyType_Text:
        {
            identifier = [identifier stringByAppendingString:@"Text"];
        }
            break;
        case eMessageBodyType_Image:
        {
            identifier = [identifier stringByAppendingString:@"Image"];
        }
            break;
        case eMessageBodyType_Voice:
        {
            identifier = [identifier stringByAppendingString:@"Audio"];
        }
            break;
        case eMessageBodyType_Location:
        {
            identifier = [identifier stringByAppendingString:@"Location"];
        }
            break;
        case eMessageBodyType_Video:
        {
            identifier = [identifier stringByAppendingString:@"Video"];
        }
            break;
            
        default:
            break;
    }
    
    return identifier;
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MMMessageModel *)model
{
    return HEAD_SIZE + CELLPADDING;
}


@end
