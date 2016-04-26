//
//  StandSpeoificationContent.h
//  jsce
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StandSpeoificationContent : NSObject

@property(nonatomic,assign)NSInteger id;//该条信息对应的ID

@property(nonatomic,strong)NSString *title;//名称

@property(nonatomic,assign)NSInteger readingCount;//关注量

@property(nonatomic,strong)NSString *createTime;//发布时间

@property(nonatomic,assign)CGFloat fileSize;//文件大小

@property(nonatomic,strong)NSString *fileName;//文件名

@property(nonatomic,strong)NSString *fileURL;//路径
@end
