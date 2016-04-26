//
//  OfficialLeftNaviButton.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficialLeftNaviButton : UIButton

@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *companyLable;
@property(nonatomic,strong)UIImageView * headPortraitView;


- (instancetype)initWithFrame:(CGRect)frame andHeadPortraitStr:(NSString *)headPortraitStr;

@end
