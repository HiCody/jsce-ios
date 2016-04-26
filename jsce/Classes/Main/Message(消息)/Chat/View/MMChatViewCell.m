//
//  MMChatViewCell.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatViewCell.h"
#import "UIResponder+Router.h"
NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";

@implementation MMChatViewCell

- (id)initWithMessageModel:(MMMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageView.layer.borderWidth = 0.5;
       
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bubbleFrame = _bubbleView.frame;
    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
    
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        _hasRead.hidden = YES;
        switch (self.messageModel.status) {
            case eMessageDeliveryState_Delivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case eMessageDeliveryState_Delivered:
            {
                [_activtiy stopAnimating];
                [_retryButton setHidden:YES];
                if (self.messageModel.message.isReadAcked)
                {
                    _activityView.hidden = NO;
                    _hasRead.hidden = NO;
                }
                else
                {
                    [_activityView setHidden:YES];
                }
            }
                break;
            case eMessageDeliveryState_Pending:
            case eMessageDeliveryState_Failure:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        if (_hasRead.hidden)
        {
            frame.size.width = SEND_STATUS_SIZE;
        }
        else
        {
            frame.size.width = _hasRead.frame.size.width;
        }
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }
    else{
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE+HEAD_PADDING;
        if (self.messageModel.messageType != eMessageTypeChat) {
            bubbleFrame.origin.y = NAME_LABEL_HEIGHT + NAME_LABEL_PADDING;
        }
        _bubbleView.frame = bubbleFrame;
    }
}

- (void)setMessageModel:(MMMessageModel *)model
{
    [super setMessageModel:model];
    
    if (model.messageType != eMessageTypeChat) {
        _nameLabel.text = model.nickName;
        _nameLabel.hidden = model.isSender;
    }
    
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - action

// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender
{
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}

#pragma mark - private

- (void)setupSubviewsForMessageModel:(MMMessageModel *)messageModel
{
    [super setupSubviewsForMessageModel:messageModel];
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //        [_retryButton setImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        //[_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        _hasRead.text = @"已读";
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
    }
    
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
}

- (MMChatBaseBubbleView *)bubbleViewForMessageModel:(MMMessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [[MMChatTextBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Image:
        {
            return [[MMChatImageBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [[MMChatAudioBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [[MMChatLocationBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [[MMChatVideoBubbleView alloc] init];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

+ (CGFloat)bubbleViewHeightForMessageModel:(MMMessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [MMChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Image:
        {
            return [MMChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [MMChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [MMChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [MMChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MMMessageModel *)model
{
    NSInteger bubbleHeight = [self bubbleViewHeightForMessageModel:model];
    NSInteger headHeight = HEAD_PADDING * 2 + HEAD_SIZE;
    if ((model.messageType != eMessageTypeChat) && !model.isSender) {
        headHeight += NAME_LABEL_HEIGHT;
    }
    return MAX(headHeight, bubbleHeight + NAME_LABEL_HEIGHT + NAME_LABEL_PADDING) + CELLPADDING;
}


@end
