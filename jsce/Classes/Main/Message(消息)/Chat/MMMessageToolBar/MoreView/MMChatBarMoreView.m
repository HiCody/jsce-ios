
//
//  MMChatBarMoreView.m
//  jsce
//
//  Created by mac on 15/10/16.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatBarMoreView.h"
#define CHAT_BUTTON_SIZE 50
#define INSETS 8
@implementation MMChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"aio_icons_pic"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"aio_icons_pic"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    
//    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
//    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
//    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
//    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_locationButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE , 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"aio_icons_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"aio_icons_camera"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    
    _fileButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_fileButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_fileButton setImage:[UIImage imageNamed:@"chatBar_colorMore_video"] forState:UIControlStateNormal];
    [_fileButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoSelected"] forState:UIControlStateHighlighted];
    [_fileButton addTarget:self action:@selector(fileAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fileButton];
    
    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        frame.size.height = 150;
        
    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = 80;
    }
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)fileAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewFileAction:)]) {
        [_delegate moreViewFileAction:self];
    }
}

@end
