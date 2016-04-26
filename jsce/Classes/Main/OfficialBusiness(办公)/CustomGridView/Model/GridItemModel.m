//
//  GridItemModel.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "GridItemModel.h"

@implementation GridItemModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)gridWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
 
        self.title            = [aDecoder decodeObjectForKey:@"title"];
        self.imageResString   = [aDecoder decodeObjectForKey:@"imageResString"];
        self.destinationClass = [aDecoder decodeObjectForKey:@"destinationClass"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title      forKey:@"title"];
    [aCoder encodeObject:self.imageResString  forKey:@"imageResString"];
    [aCoder encodeObject:self.destinationClass      forKey:@"destinationClass"];
    
}

@end
