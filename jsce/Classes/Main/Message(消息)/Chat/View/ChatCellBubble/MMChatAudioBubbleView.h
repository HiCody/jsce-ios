//
//  MMChatAudioBubbleView.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatBaseBubbleView.h"
#define ANIMATION_IMAGEVIEW_SIZE 25 // 小喇叭图片尺寸
#define ANIMATION_IMAGEVIEW_Height 30 // 小喇叭图片尺寸
#define ANIMATION_IMAGEVIEW_SPEED 1 // 小喇叭动画播放速度


#define ANIMATION_TIME_IMAGEVIEW_PADDING 5 // 时间与动画间距


#define ANIMATION_TIME_LABEL_WIDHT 30 // 时间宽度
#define ANIMATION_TIME_LABEL_HEIGHT 15 // 时间高度
#define ANIMATION_TIME_LABEL_FONT_SIZE 14 // 时间字体

// 发送
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"SenderVoiceNodePlaying" // 小喇叭默认图片
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_01 @"SenderVoiceNodePlaying000" // 小喇叭动画第一帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_02 @"SenderVoiceNodePlaying001" // 小喇叭动画第二帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_03 @"SenderVoiceNodePlaying002" // 小喇叭动画第三帧
#define SENDER_ANIMATION_IMAGEVIEW_IMAGE_04 @"SenderVoiceNodePlaying003" // 小喇叭动画第四帧


// 接收
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_DEFAULT @"ReceiverVoiceNodePlaying" // 小喇叭默认图片
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_01 @"ReceiverVoiceNodePlaying000" // 小喇叭动画第一帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_02 @"ReceiverVoiceNodePlaying001" // 小喇叭动画第二帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_03 @"ReceiverVoiceNodePlaying002" // 小喇叭动画第三帧
#define RECEIVER_ANIMATION_IMAGEVIEW_IMAGE_04 @"ReceiverVoiceNodePlaying003" // 小喇叭动画第四帧
extern NSString *const kRouterEventAudioBubbleTapEventName;

@interface MMChatAudioBubbleView : MMChatBaseBubbleView
{
    UIImageView *_animationImageView; // 动画的ImageView
    UILabel *_timeLabel; // 时间label
}

-(void)startAudioAnimation;
-(void)stopAudioAnimation;
@end
