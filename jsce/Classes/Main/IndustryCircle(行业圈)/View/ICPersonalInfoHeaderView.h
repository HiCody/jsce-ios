//
//  ICPersonalInfoHeaderView.h
//  jsce
//
//  Created by mac on 15/9/24.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICPersonalInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *userCompanyLable;
@property (weak, nonatomic) IBOutlet UILabel *userPostLable;

@property (weak, nonatomic) IBOutlet UILabel *userIphoneLable;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLable;
@property (weak, nonatomic) IBOutlet UILabel *userHometownLable;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

+ (instancetype)iCPersonalInfoHeaderView;
@end
