//
//  MMApplyDetailViewController.m
//  jsce
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMApplyDetailViewController.h"
#import "JsceBaseTableView.h"
#import "MMContactCell.h"
#import "MMApplyFriendViewController.h"
#import "ICPersonalInfoVC.h"
//@class MMApplyFriendViewController;
@interface MMApplyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
   
}
@property(nonatomic,strong)JsceBaseTableView *tableView;
@end

@implementation MMApplyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友申请";
    self.showBackBtn = YES;
    self.view.backgroundColor  = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView{
    self.tableView = [[JsceBaseTableView alloc] init];
    self.tableView.frame=CGRectMake(0, 10, screenWidth, self.view.bounds.size.height-10);
    self.tableView.delegate=self;
    self.tableView.dataSource   =self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];;
    self.tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    UIView *view1=[self bottomView];
    view1.frame=CGRectMake(0, 160, screenWidth, 100);
    [self.view addSubview:view1 ];
}

- (UIView *)bottomView{
    UIView *backView= [[UIView alloc] init];
    backView.backgroundColor=[UIColor clearColor];
    UIButton *refuseButton = [[UIButton alloc] init];
    [refuseButton addTarget:self action:@selector(applyRefuseFriend) forControlEvents:UIControlEventTouchUpInside];
     refuseButton.backgroundColor  = [UIColor whiteColor];
    [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseButton setTitleColor:NAVBAR_COLOR forState:UIControlStateNormal];
    refuseButton.layer.borderWidth=0.5;
    refuseButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    refuseButton.layer.cornerRadius=5.0;
    refuseButton.titleLabel.font= [UIFont systemFontOfSize:17.0];
    refuseButton.frame =CGRectMake(15, 50, (screenWidth-3*15)/2, 40);
    [backView addSubview:refuseButton];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(applyCellAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor  = NAVBAR_COLOR;
    [addBtn setTitle:@"同意" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.layer.borderWidth=0.5;
    addBtn.layer.borderColor = NAVBAR_COLOR.CGColor;
    addBtn.layer.cornerRadius=5.0;
    addBtn.titleLabel.font= [UIFont systemFontOfSize:17.0];
    addBtn.frame =CGRectMake((screenWidth-3*15)/2+2*15, 50, (screenWidth-3*15)/2, 40);
    [backView addSubview:addBtn];
    
    return backView;
}


- (void)applyRefuseFriend{
    [self showHudInView:self.view hint:@"正在发送申请..."];
 
    ApplyStyle applyStyle = [self.applyEntity.style intValue];
    EMError *error;
    
    if (applyStyle == ApplyStyleGroupInvitation) {
        [[EaseMob sharedInstance].chatManager rejectInvitationForGroup:self.applyEntity.groupId toInviter:self.applyEntity.applicantUsername reason:@""];
    }
    else if (applyStyle == ApplyStyleJoinGroup)
    {
        [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:self.applyEntity.groupId groupname:self.applyEntity.groupSubject toApplicant:self.applyEntity.applicantUsername reason:nil];
    }
    else if(applyStyle == ApplyStyleFriend){
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:self.applyEntity.applicantUsername reason:@"" error:&error];
    }
    
    [self hideHud];
    if (!error) {
        [self showHint:@"已拒绝"];
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        [[InvitationManager sharedInstance] removeInvitation:self.applyEntity loginUser:loginUsername];
        [[MMApplyFriendViewController shareController].dataSource removeObject:self.applyEntity];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self showHint:@"拒绝失败"];
    }

}

- (void)applyCellAddFriend:(UIButton *)btn{
    [self showHudInView:self.view hint:@"正在发送申请..."];
    
   
    ApplyStyle applyStyle = [self.applyEntity.style intValue];
    EMError *error;
    
    if (applyStyle == ApplyStyleJoinGroup)
     {
         [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:self.applyEntity.groupId groupname:self.applyEntity.groupSubject applicant:self.applyEntity.applicantUsername error:&error];
     }
     else if(applyStyle == ApplyStyleFriend){
         [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.applyEntity.applicantUsername error:&error];
     }
    
    [self hideHud];
    if (!error) {
        [self showHint:@"添加成功"];
        NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
        [[InvitationManager sharedInstance] removeInvitation:self.applyEntity loginUser:loginUsername];
         [[MMApplyFriendViewController shareController].dataSource removeObject:self.applyEntity];
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self showHint:@"接受失败"];
    }

}

#pragma  mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MMContactCell   *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.headImageView.image =self.applyEntity.image;
        cell.imgHeight=50;
        cell.nameLable.text=self.applyEntity.applicantUsername;
        cell.nameLable.font= [UIFont systemFontOfSize:19.0];
        cell.detailLable.text=@"北京公司";
        cell.detailLable.font=[UIFont systemFontOfSize:15.0];
        cell.detailLable.textColor =[UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else{
        cell.textLabel.text = @"附加信息";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14.0];
        
        UILabel *contentLable = [[UILabel alloc] init];
        contentLable.numberOfLines  = 0;
        contentLable.font=[UIFont systemFontOfSize:15.0];
        contentLable.text = self.applyEntity.reason;
        CGSize contentSize= [self sizeWithText:contentLable.text font:contentLable.font maxSize:CGSizeMake(screenWidth-100,MAXFLOAT)];
        contentLable.frame =CGRectMake(100, (90-contentSize.height)/2, contentSize.width, contentSize.height);
        
        [cell.contentView addSubview:contentLable];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }else{
  
        return 90;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        
        ICPersonalInfoVC *icPIVC= [[ICPersonalInfoVC alloc] init];
        ICMessageBody *message = [[ICMessageBody alloc] init];
        message.posterName = self.applyEntity.applicantUsername;
        icPIVC.messageBody = message;
        
        [self.navigationController pushViewController:icPIVC animated:YES];
    }
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
