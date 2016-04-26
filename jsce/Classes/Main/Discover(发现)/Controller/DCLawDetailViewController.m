//
//  DCLawDetailViewController.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCLawDetailViewController.h"
#import <TOWebViewController.h>
@class DCLawViewController;
@interface DCLawDetailViewController ()<UIWebViewDelegate>

@end

@implementation DCLawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"法律法规详细";
    self.showPageTitles=NO;
    self.webView.delegate=self;
    self.showUrlWhileLoading=NO;

    [self configBackBtn];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBackBtn{
    UIButton *btn=[[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];

    UIBarButtonItem *barBI=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_back"] style:UIBarButtonItemStyleDone target:self action:@selector(pushBack)];
    
    self.navigationItem.leftBarButtonItem  = barBI;
}

- (void)pushBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark WebView
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];//修改百分比即可
}

@end
