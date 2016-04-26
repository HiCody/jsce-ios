//
//  FilterFirstColumnCell.h
//  Filter
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterFirstColumnCell : UITableViewCell

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,assign)CGFloat cellHeight;//cell的高度
@end
