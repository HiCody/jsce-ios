//
//  ICHeadView.h
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *preferenceLable;

@property (weak, nonatomic) IBOutlet UIButton *preferenceButton;

+ (instancetype)ICHeadView;
@end
