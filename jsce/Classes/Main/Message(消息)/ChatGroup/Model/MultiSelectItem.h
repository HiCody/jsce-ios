//
//  MultiSelectItem.h
//  jsce
//
//  Created by mac on 15/10/20.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiSelectItem : NSObject
@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *imageUrl;

@property (nonatomic, assign) BOOL disabled; //是否不让选择
@property (nonatomic, assign) BOOL selected; //是否已经被选择

@end
