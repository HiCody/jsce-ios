//
//  DCDownloadFootView.h
//  jsce
//
//  Created by mac on 15/9/30.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCDownloadFootView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelDownloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *openFileBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet UIView *btnView;

+ (instancetype)dcDownloadFootView;
@end
