//
//  MMChatBarMoreView.h
//  jsce
//
//  Created by mac on 15/10/16.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;
@protocol ChatBarMoreViewDelegate ;
@interface MMChatBarMoreView : UIView

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *fileButton;
@property (nonatomic,assign) id<ChatBarMoreViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

@end

@protocol ChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(MMChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(MMChatBarMoreView *)moreView;
- (void)moreViewFileAction:(MMChatBarMoreView *)moreView;


@end
