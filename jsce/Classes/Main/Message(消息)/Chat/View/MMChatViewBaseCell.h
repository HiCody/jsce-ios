//
//  MMCharViewBaseCell.h
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMChatBaseBubbleView.h"
#import "UIResponder+Router.h"
#import "MMMessageModel.h"
#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距

#define NAME_LABEL_WIDTH 180 // nameLabel最大宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 5 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

extern NSString *const kRouterEventChatHeadImageTapEventName;

@interface MMChatViewBaseCell : UITableViewCell
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    MMChatBaseBubbleView *_bubbleView;
    
    CGFloat _nameLabelHeight;
    MMMessageModel *_messageModel;
}

@property (nonatomic, strong) MMMessageModel *messageModel;

@property (nonatomic, strong) UIImageView *headImageView;       //头像
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（暂时不支持显示）
@property (nonatomic, strong) MMChatBaseBubbleView *bubbleView;   //内容区域

- (id)initWithMessageModel:(MMMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupSubviewsForMessageModel:(MMMessageModel *)model;

+ (NSString *)cellIdentifierForMessageModel:(MMMessageModel *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MMMessageModel *)model;
@end
