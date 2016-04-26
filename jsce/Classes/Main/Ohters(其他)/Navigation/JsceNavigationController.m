//
//  JsceNavigationController.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "JsceNavigationController.h"

@interface JsceNavigationController ()

@end

@implementation JsceNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)initialize{
    
    UINavigationBar *naviBar=[UINavigationBar appearance];
    naviBar.translucent=YES;
   // naviBar.barTintColor = NAVBAR_COLOR;
    [naviBar setBackgroundImage:[UIImage imageNamed:@"navi_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    [naviBar setTintColor:[UIColor whiteColor]];
}


//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    viewController.hidesBottomBarWhenPushed=YES;
//    
//    [super pushViewController:viewController animated:animated];
//}

@end
