//
//  DCQueryBaseTableView.m
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCQueryBaseTableView.h"

@implementation DCQueryBaseTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}



@end
