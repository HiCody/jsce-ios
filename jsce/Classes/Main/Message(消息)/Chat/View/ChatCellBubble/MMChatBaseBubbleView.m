

//
//  MMChatBaseBubbleView.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatBaseBubbleView.h"
NSString *const kRouterEventChatCellBubbleTapEventName = @"kRouterEventChatCellBubbleTapEventName";

@implementation MMChatBaseBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.multipleTouchEnabled = YES;
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_backImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewPressed:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - setter

- (void)setModel:(MMMessageModel *)model
{
    _model = model;
    
    BOOL isReceiver = !_model.isSender;
    NSString *imageName = isReceiver ? BUBBLE_LEFT_IMAGE_NAME : BUBBLE_RIGHT_IMAGE_NAME;
    NSInteger leftCapWidth = isReceiver?BUBBLE_LEFT_LEFT_CAP_WIDTH:BUBBLE_RIGHT_LEFT_CAP_WIDTH;
    NSInteger topCapHeight =  isReceiver?BUBBLE_LEFT_TOP_CAP_HEIGHT:BUBBLE_RIGHT_TOP_CAP_HEIGHT;
#pragma  mark 拉伸
    self.backImageView.image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

#pragma mark - public

+ (CGFloat)heightForBubbleWithObject:(MMMessageModel *)object
{
    return 30;
}

- (void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventChatCellBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

- (void)progress:(CGFloat)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end

