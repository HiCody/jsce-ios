//
//  DCDownloadCell.h
//  jsce
//
//  Created by mac on 15/9/30.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCDownloadCell : UITableViewCell

@property(nonatomic,strong)NSString *titleStr;

@property(nonatomic,strong)UILabel *titleLable;

@property(nonatomic,strong)UILabel *fileSizeLable;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,strong)NSString *fileSizeStr;

@property(nonatomic,assign)BOOL isShow;

@property(nonatomic,strong)UIProgressView *progressView;

- (void)setTitleStr:(NSString *)titleStr andFileSizeStr:(NSString *)fileSizeStr andIsShow:(BOOL)isShow;
@end
