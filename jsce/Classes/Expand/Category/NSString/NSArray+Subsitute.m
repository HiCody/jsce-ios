//
//  NSArray+Subsitute.m
//  jsce
//
//  Created by mac on 15/9/18.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "NSArray+Subsitute.h"

@implementation NSArray (Subsitute)

- (NSArray *)offsetRangesInArrayBy:(NSUInteger)offset
{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    
    
    NSMutableArray *ranges = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for(NSInteger i = 0; i < [self count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[self objectAtIndex:i] rangeValue];
            prevLength    = range.length;
            
            range.location -= aOffset;
            range.length    = offset;
            [ranges addObject:NSStringFromRange(range)];
            
            aOffset = aOffset + prevLength - offset;
        }
    }
    
    return ranges;
}

@end
