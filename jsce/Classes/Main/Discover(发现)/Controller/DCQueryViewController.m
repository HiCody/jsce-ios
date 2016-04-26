//
//  DCQueryViewController.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCQueryViewController.h"
#import "HMSegmentedControl.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface DCQueryViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)HMSegmentedControl *segmentedControl;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation DCQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查价格";
    self.showBackBtn= YES;
    
    [self configSegment];
    
    [self configNaviRightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)configNaviRightButton{
    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"无锡" action:^{
        
    }];
 
}


//配置自定义segment
-(void)configSegment{
    UIScrollView *segScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    segScroll.contentSize = CGSizeMake(W(400), 35);
    segScroll.showsHorizontalScrollIndicator= NO;
    segScroll.bounces = NO;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, W(400), 40)];
    self.segmentedControl.sectionTitles = @[@"关注", @"土建",@"装饰",@"安装",@"周转"];
    self.segmentedControl.verticalDividerWidth=1;

    self.segmentedControl.verticalDividerColor=NAVBAR_COLOR;
    self.segmentedControl.verticalDividerEnabled = YES;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : NAVBAR_COLOR,NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    
    self.segmentedControl.selectionIndicatorColor=NAVBAR_COLOR;
    self.segmentedControl.selectionIndicatorHeight=2.0;

    self.segmentedControl.borderType=HMSegmentedControlBorderTypeBottom;
    self.segmentedControl.borderWidth=2.0;
    self.segmentedControl.borderColor=[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
//    __weak typeof(self) weakSelf = self;
//    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
//        
//        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, self.view.frame.size.height-50) animated:YES];
//    }];
//
    [segScroll addSubview:self.segmentedControl];
   [self.view addSubview:segScroll];
//    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height-115)];
//    self.scrollView.backgroundColor = [UIColor redColor];
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.contentSize = CGSizeMake(viewWidth * 2,self.view.frame.size.height-115);
//    self.scrollView.delegate = self;
//    self.scrollView.bounces=NO;
//    
//    [self.view addSubview:self.scrollView];

}
@end
