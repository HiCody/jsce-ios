//
//  ICMessageBody.h
//  jsce
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMessageBody : NSObject

/**
 *  用户头像url 此处直接用图片名代替
 */
@property (nonatomic,copy) NSString *posterImgstr;//

/**
 *  用户名
 */
@property (nonatomic,copy) NSString *posterName;

/**
 *  vip
 */
@property (nonatomic,assign) BOOL isVip;
/**
 *  职务
 */
@property (nonatomic,copy) NSString *post;

/**
 *  发布时间
 */
@property (nonatomic,copy) NSString *releaseTime;

/**
 *  用户说说内容
 */
@property (nonatomic,copy) NSString *posterContent;//

/**
 *  地理位置
 */
@property (nonatomic,copy)NSString *locationStr;

/**
 *  用户发送的图片数组
 */
@property (nonatomic,strong) NSArray *posterPostImage;//

/**
 *  用户收到的赞 (该数组存点赞的人的昵称)   收藏的用户（该数组存收藏的人的昵称）
 */
@property (nonatomic,strong) NSMutableArray *posterFavour;

/**
 *  用户说说的评论数组
 */
@property (nonatomic,strong) NSMutableArray *posterReplies;//

/**
 *  admin是否收藏过
 */
@property (nonatomic,assign) BOOL isFavour;


@end
