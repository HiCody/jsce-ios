//
//  NSObject+Subsitute.h
//  jsce
//
//  Created by mac on 15/9/18.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Subsitute)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString;


- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index;


@end
