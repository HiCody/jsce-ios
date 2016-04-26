//
//  MMChatViewCell.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MMChatViewBaseCell.h"
#import "MMChatTextBubbleView.h"
#import "MMChatImageBubbleView.h"
#import "MMChatAudioBubbleView.h"   
#import "MMChatVideoBubbleView.h"
#import "MMChatLocationBubbleView.h"  


#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kShouldResendCell;


@interface MMChatViewCell : MMChatViewBaseCell

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *hasRead;

@end
