//
//  MMIdentityVerificationViewController.m
//  jsce
//
//  Created by mac on 15/10/12.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMIdentityVerificationViewController.h"
#import "JsceBaseTableView.h"
#import "MMContactCell.h"

@interface MMIdentityVerificationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>{
    
}
@property(nonatomic,strong)JsceBaseTableView *tableView;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *statusLabel;
@end

@implementation MMIdentityVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"身份验证";
    self.showBackBtn = YES;
    
    self.view.backgroundColor=  [UIColor hexFloatColor:@"ededed"];
    
    [self setUpTableView];
    
    [self addRightBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView{
    self.tableView = [[JsceBaseTableView alloc] init];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.frame=self.view.bounds;
    self.tableView.delegate=self;
    self.tableView.dataSource =self;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
}

- (void)addRightBtn{
    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"发送" action:^{
        [self showHudInView:self.tableView hint:@"请求中..."];
        
        EMError *error;
        [[EaseMob sharedInstance].chatManager addBuddy:self.nameStr message:_textView.text error:&error];
        [self hideHud];
        if (error) {
            [self showHint:@"好友请求失败"];
        }
        else{
            [self showHint:@"好友请求发送成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MMContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        //  cell.backgroundColor=[UIColor clearColor];
        cell.imgHeight=50;
        cell.headImageView.image = [UIImage imageNamed:@"头像1"];
        cell.nameLable.text = self.nameStr;
        cell.nameLable.font= [UIFont systemFontOfSize:19.0];
        cell.detailLable.text=@"北京公司";
        cell.detailLable.textColor=[UIColor grayColor];
        cell.detailLable.font = [UIFont systemFontOfSize:14.0];
        
    }else{
        _textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, 150)];
        _textView.backgroundColor =  [UIColor whiteColor];
        _textView.delegate=self;
        _textView.font = [UIFont systemFontOfSize:15.0];
        _textView.text=@"我是";
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment=NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:15.0];
        _statusLabel.frame=CGRectMake(0, 150-16.0, screenWidth, 16.0);
        [_textView addSubview:_statusLabel];
        [cell.contentView addSubview:_textView];
    }
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }else{
        return 150;
    }
}

//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 12) {
        
        textView.text = [textView.text substringToIndex:12];
        [textView resignFirstResponder];
        //   [alert release];
        number = 12;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"%ld/12",number];
}
@end
