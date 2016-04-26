//
//  FilterHeardView.h
//  jsce
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterHeardView : UIView
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UILabel *titleLable;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,assign)NSInteger selectedIndex;

- (void)setBtnTitleWithArr:(NSArray *)titleArr;

- (void)reloadData;
@end
