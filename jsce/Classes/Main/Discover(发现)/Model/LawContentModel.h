//
//  LawContentModel.h
//  jsce
//
//  Created by mac on 15/11/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LawContentModel : NSObject

@property(nonatomic,strong)NSString *lawsId;//该条信息对应的ID

@property(nonatomic,strong)NSString *title;//名称

@property(nonatomic,strong)NSString *shortInfo;//描述

@property(nonatomic,strong)NSString *areaName;//地址

@property(nonatomic,strong)NSString *createTime;//发布时间

@property(nonatomic,assign)NSInteger readingCount;//查看量

@property(nonatomic,assign)NSInteger firstId;//一级查询ID

@property(nonatomic,assign)NSInteger secondId;//二级查询ID

@end
