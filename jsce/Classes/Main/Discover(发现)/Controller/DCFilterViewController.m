//
//  DCFilterViewController.m
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCFilterViewController.h"
#import "FilterHeardView.h"
#import "MultilevelMenu.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2

#define kHeadViewHeight 50
#define kBottomBarHeight 60

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCFilterViewController (){
    CGFloat topHeight;
}
@property(nonatomic,strong)FilterHeardView *filterHV;
@property(nonatomic,strong)MultilevelMenu  *muMenu;
@property(nonatomic,strong)UIButton *sureBtn;

@end

@implementation DCFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    topHeight=rectStatus.size.height+rectNav.size.height;
    
    self.title = @"筛选";
    self.showBackBtn  =YES;
    
    [self configRightBtn];
    
    [self configHeardView];
    
    [self configMultileveMenu];
    
   [self configBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)configRightBtn{
    [self  actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"恢复默认" action:^{
        self.muMenu.selectedRightIndex=-1;
        self.muMenu.lastLeftIndex=-1;
        [self.muMenu reloadData];
        self.muMenu.needToScorllerIndex=0;
        [self.filterHV reloadData];
        self.filterHV.selectedIndex=-1;
    }];
}

- (void)configHeardView{
    self.filterHV=[[FilterHeardView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, kHeadViewHeight)];
    self.filterHV.titleLable.text=@"实施日期";
    self.filterHV.backgroundColor=UIColorFromRGB(0xF3F4F6);
    NSArray *titleArr = @[@"2015",@"2014",@"2013",@"2012以前"];
    
    [self.filterHV setBtnTitleWithArr:titleArr];
    
    [self.view addSubview:self.filterHV];
}

- (void)configMultileveMenu{
    self.muMenu = [[MultilevelMenu alloc] initWithFrame:CGRectMake(0, kHeadViewHeight, WinWidth, WinHeight-kHeadViewHeight-kBottomBarHeight-topHeight)];
    
    self.muMenu.firstColumnArr=self.firstColumnArr;
    self.muMenu.secondColumnArr = self.secondColumnArr;
    self.muMenu.needToScorllerIndex=0;
    [self.view addSubview:self.muMenu];
}

- (void)configBottomView{
    self.sureBtn  = [[UIButton alloc] init];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureBtn.backgroundColor    = [UIColor orangeColor];
    self.sureBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    
    self.sureBtn.frame=CGRectMake(10, 10, WinWidth-2*10, kBottomBarHeight-2*10);
    [self.sureBtn addTarget:self action:@selector(ensureData) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kBottomBarHeight-topHeight, WinWidth, kBottomBarHeight)];
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 1)];
    lineView.backgroundColor=UIColorFromRGB(0xE5E5E5);
    [bottomView addSubview:lineView];
    bottomView.backgroundColor=UIColorFromRGB(0xF3F4F6);
    [bottomView addSubview:self.sureBtn];
    [self.view addSubview:bottomView];
    
}

//TODO: 传递数据，重新请求
- (void)ensureData{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.muMenu.selectedRightIndex inSection:self.muMenu.lastLeftIndex];
  
    self.refreshByFilter(self.filterHV.selectedIndex,indexPath);

    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
