//
//  BaseLoadView.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "BaseLoadView.h"
@interface BaseLoadView ()
{
    UIActivityIndicatorView *loadView;
}

@end
@implementation BaseLoadView

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if(loadView)
    {
        [loadView stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
        
        
        loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadView.frame = CGRectMake((frame.size.width - 32) / 2, frame.size.height / 2 - 100, 32, 32);
        [loadView startAnimating];
        [self addSubview:loadView];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 100) / 2, loadView.frame.origin.y + 40, 100, 100)];
        img.image = [UIImage imageNamed:@"mainBg"];
        [self addSubview:img];
    }
    return self;
}


@end
