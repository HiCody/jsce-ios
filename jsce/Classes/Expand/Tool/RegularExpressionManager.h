//
//  RegularExpressionManager.h
//  jsce
//
//  Created by mac on 15/9/17.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularExpressionManager : NSObject

+ (NSArray *)itemIndexesWithPattern:(NSString *)pattern inString:(NSString *)findingString;

+ (NSMutableArray *)matchMobileLink:(NSString *)pattern;

+ (NSMutableArray *)matchWebLink:(NSString *)pattern;

@end
