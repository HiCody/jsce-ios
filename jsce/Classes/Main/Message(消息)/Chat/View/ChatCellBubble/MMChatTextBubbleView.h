//
//  MMChatTextBubbleView.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MMChatBaseBubbleView.h"

#define TEXTLABEL_MAX_WIDTH 200 // textLaebl 最大宽度
#define LABEL_FONT_SIZE 15      // 文字大小
#define LABEL_LINESPACE 2       // 行间距

extern NSString *const kRouterEventTextURLTapEventName;
extern NSString *const kRouterEventMenuTapEventName;

@interface MMChatTextBubbleView : MMChatBaseBubbleView{
    NSDataDetector *_detector;
    NSArray *_urlMatches;
}

@property (nonatomic, strong) UILabel *textLabel;
+ (CGFloat)lineSpacing;
+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;
- (void)highlightLinksWithIndex:(CFIndex)index;

@end
