//
//  MMChatListCell.h
//  jsce
//
//  Created by 顾佳洪 on 15/10/19.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMChatListCell : UITableViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger unreadCount;

+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
