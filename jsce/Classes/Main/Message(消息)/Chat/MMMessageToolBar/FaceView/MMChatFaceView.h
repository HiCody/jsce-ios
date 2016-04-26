//
//  MMChatFaceView.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShowFaceViewType) {
    ShowEmojiFace = 0,
    ShowRecentFace,
    ShowGifFace,
};

@protocol ChatFaceViewDelegate <NSObject>

- (void)faceViewSendFace:(NSString *)faceName;

@end

@interface MMChatFaceView : UIView

@property (weak, nonatomic) id<ChatFaceViewDelegate> delegate;
@property (assign, nonatomic) ShowFaceViewType faceViewType;

@end
