//
//  GridItemModel.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridItemModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * imageResString;
@property (nonatomic, strong) NSString * destinationClass;

+ (instancetype)gridWithDict:(NSDictionary *)dict;
@end
