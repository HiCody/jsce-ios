//
//  JsceBaseVC.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"
#import "BaseLoadView.h"
#import "BaseNoDataView.h"
@interface JsceBaseVC ()<UIGestureRecognizerDelegate>
{
    BaseNoDataView      *viewEmpty;
    BaseLoadView        *viewLoad;
}


@end

@implementation JsceBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    viewEmpty = [[BaseNoDataView alloc] initWithFrame:self.view.bounds];
    viewLoad = [[BaseLoadView alloc] initWithFrame:self.view.bounds];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger count = self.navigationController.viewControllers.count;
    self.navigationController.interactivePopGestureRecognizer.enabled = count > 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        
        return YES;
    }
}

#pragma mark - Empty
- (void)showEmpty
{
    viewEmpty.frame = self.view.bounds;
    [self.view addSubview:viewEmpty];
}

- (void)showEmpty:(CGRect)frame
{
    viewEmpty.frame = frame;
    [self.view addSubview:viewEmpty];
}

- (void)hideEmpty
{
    [viewEmpty removeFromSuperview];
}
#pragma mark - load
- (void)showLoad
{
    viewLoad.frame = self.view.bounds;
    [self.view addSubview:viewLoad];
}
- (void)hideLoad
{
    [viewLoad removeFromSuperview];
}


@end
