//
//  XBBaseVC.m
//  ZJOL
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/6.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "XBBaseVC.h"

#import <objc/runtime.h>

#import "UIColor+hexColor.h"

static char *btnClickAction;

@implementation XBBaseVC
@synthesize showBackBtn;

- (id)init {
    if (self = [super init]) {
        if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)])
        {
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
        if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        if([self respondsToSelector:@selector(setModalPresentationCapturesStatusBarAppearance:)])
        {
            self.modalPresentationCapturesStatusBarAppearance = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [NAVBAR_COLOR CGColor]);
    CGContextFillRect(context, rect);
 //       UIImage *imge = [UIImage imageNamed:@"Login_back"];

    UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:imge forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:20];

    self.navigationController.navigationBar.titleTextAttributes = attrs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -actionCustomLeftBtnWithNrlImage
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock {
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftBtn setBackgroundColor:[UIColor clearColor]];
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage htlImage:hltImage title:title];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
}

#pragma mark -actionCustomRightBtnWithNrlImage
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage htlImage:hltImage title:title];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}

#pragma mark -actionCustomNavBtn
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
   // [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    if (hltImage) {
        [btn setImage:[UIImage imageNamed:hltImage] forState:UIControlStateHighlighted];
    }
    if(nrlImage) {
        [btn setImage:[UIImage imageNamed:nrlImage] forState:UIControlStateNormal];
    }
    if (title) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
    }
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -actionBtnClick
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    btnClickBlock();
}

#pragma mark -getter or setter
- (void)setItemTitle:(NSString *)title {
    _itemTitle = title;
    [self.navigationItem setTitle:_itemTitle];
}

- (void)setShowBackBtn:(BOOL)showBack {
    __weak typeof(self) wSelf = self;
    // TODO TODO TODO - how to deal with the image resources?
    [self actionCustomLeftBtnWithNrlImage:@"login_back" htlImage:nil title:nil action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
}



@end
