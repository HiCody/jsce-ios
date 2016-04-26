//
//  MMChatViewController.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"
@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end
@interface MMChatViewController : JsceBaseVC
@property (nonatomic) EMConversationType conversationType;
@property (strong, nonatomic, readonly) NSString *chatter;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

#pragma mark - sendMessage
-(void)sendTextMessage:(NSString *)textMessage;
-(void)sendImageMessage:(UIImage *)image;
-(void)sendAudioMessage:(EMChatVoice *)voice;
-(void)sendVideoMessage:(EMChatVideo *)video;
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
-(void)addMessage:(EMMessage *)message;
- (EMMessageType)messageType;

@end
