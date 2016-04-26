//
//  MessageModelManager.m
//  jsce
//
//  Created by mac on 15/10/19.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MessageModelManager.h"
#import "MMMessageModel.h"
#import "UserProfileManager.h"
@implementation MessageModelManager
+ (id)modelWithMessage:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    NSString *sender = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
    BOOL isSender = [login isEqualToString:sender] ? YES : NO;
    
    MMMessageModel *model = [[MMMessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.isSender = isSender;
    model.isPlaying = NO;
    model.messageType = message.messageType;
    

    
    if (model.messageType != eMessageTypeChat) {
        model.username = message.groupSenderName;
    }
    else{
        model.username = message.from;
        
    }
    
  NSArray *useArr =  [[UserProfileManager sharedInstance] contactListWithloginUser:login];
    for (UserProfileEntity *user in useArr) {
        if ([user.username isEqualToString:model.username]) {
            
            model.headImage = user.image;
         
        }
    }
    
    
    /*
     if (isSender) {
     model.headImageURL = nil;
     }
     else{
     model.headImageURL = nil;
     }
     */
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 表情映射。
//            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
//                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.content = ((EMTextMessageBody *)messageBody).text;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case eMessageBodyType_Location:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case eMessageBodyType_Voice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [message updateMessageExtToDB];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case eMessageBodyType_Video:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.size;
            model.size = videoMessageBody.size;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
        default:
            break;
    }
    
    return model;
}

@end
