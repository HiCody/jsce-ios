//
//  ICReplyBody.h
//  jsce
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICReplyBody : NSObject

/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUser;


/**
 *  回复该评论者的人
 */
@property (nonatomic,copy) NSString *repliedUser;

/**
 *  回复内容
 */
@property (nonatomic,copy) NSString *replyInfo;


@end
