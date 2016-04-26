//
//  MMChatImageBubbleView.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface MMChatImageBubbleView : MMChatBaseBubbleView

@property (nonatomic, strong) UIImageView *imageView;

@end
