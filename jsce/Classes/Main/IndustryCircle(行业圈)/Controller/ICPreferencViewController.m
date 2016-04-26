//
//  ICPreferencViewController.m
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICPreferencViewController.h"

@interface ICPreferencViewController ()

@end

@implementation ICPreferencViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置偏好";

    self.showBackBtn =YES;
    ICPreferenceView *icp=[ICPreferenceView ICPreferenceView];
    icp.frame=self.view.frame;
    [self.view addSubview:icp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
