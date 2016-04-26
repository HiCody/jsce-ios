//
//  NSObject+Subsitute.m
//  jsce
//
//  Created by mac on 15/9/18.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "NSString+Subsitute.h"

@implementation NSString (Subsitute)

- (NSString *)replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString{
    
    NSUInteger offset = 0;
    NSMutableString *raw= [self mutableCopy];
    
    NSInteger pveLength =  0;
    for (NSInteger i=0; i<[indexes count]; i++) {
        NSRange rang = [[indexes objectAtIndex:i] rangeValue];
        
        rang.location-=offset;
        pveLength =rang.length;
        
        [raw replaceCharactersInRange:rang withString:aString];
        offset =  offset + pveLength - [aString length];
    }
    
    return raw;
}

- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
        
        return results;
    }
    
    return nil;
}

@end
