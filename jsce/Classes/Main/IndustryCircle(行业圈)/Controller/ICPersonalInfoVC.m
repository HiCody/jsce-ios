//
//  ICPersonalInfoVC.m
//  jsce
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICPersonalInfoVC.h"
#import "ICPersonalInfoHeaderView.h"
#import "MMIdentityVerificationViewController.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2


@interface ICPersonalInfoVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *contactBtn; //直接联系
@property(nonatomic,strong)UIButton *addBtn; //加好友按钮
@end

@implementation ICPersonalInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeAll;
  
    self.title  =@"个人详情";
    self.view.backgroundColor=  [UIColor hexFloatColor:@"ededed"];
    self.showBackBtn=  YES;
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTableView{
    self.contactBtn = [[UIButton alloc] init];
    [self.contactBtn setTitle:@"直接联系" forState:UIControlStateNormal];
    [self.contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.contactBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.contactBtn.frame=CGRectMake(0, WinHeight-50, WinWidth/2.0-1, 50);
    self.contactBtn.backgroundColor=[UIColor hexFloatColor:@"1E99FF"];
    self.contactBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:self.contactBtn];
    
    self.addBtn = [[UIButton alloc] init];
    [self.addBtn setTitle:@"+加好友" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(identifierVerification:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    self.addBtn.frame=CGRectMake(WinWidth/2.0, WinHeight-50, WinWidth/2.0, 50);
    self.addBtn.backgroundColor=[UIColor hexFloatColor:@"1E99FF"];
    [self.view addSubview:self.addBtn];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    CGFloat topHeight=rectStatus.size.height+rectNav.size.height;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topHeight, WinWidth, WinHeight-50-topHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.bounces=NO;
    
    ICPersonalInfoHeaderView *icPIHV=[ICPersonalInfoHeaderView iCPersonalInfoHeaderView];
    icPIHV.frame=CGRectMake(10, 10, WinWidth-2*10, 150);
    [icPIHV.userImageView sd_setImageWithURL:[NSURL URLWithString:self.messageBody.posterImgstr] placeholderImage:[UIImage imageNamed:@"timeline_image_loading"]];
    icPIHV.vipImageView.hidden=!self.messageBody.isVip;
    icPIHV.userNameLable.text = self.messageBody.posterName;
    icPIHV.layer.borderWidth=0.5;
    icPIHV.layer.borderColor=[UIColor hexFloatColor:@"dadada"].CGColor;
    
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 170)];
    backView.backgroundColor  = [UIColor clearColor];
    [backView addSubview:icPIHV];
    
    self.tableView.tableHeaderView =backView;
  
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
}

//添加好友
- (void)identifierVerification:(UIButton *)btn{
    MMIdentityVerificationViewController *mmivVC=[[MMIdentityVerificationViewController alloc] init];
    mmivVC.nameStr = self.messageBody.posterName;
    [self.navigationController pushViewController:mmivVC animated:YES];
}

#pragma  mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
   UITableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text =@"他的动态";
        }else{
            cell.textLabel.text =@"他的好友";
        }
        
    }else{
        
        NSArray *arr=@[@"通州建总集团",@"南通四建集团",@"南通三建集团"];
        NSArray *arr2=@[@"2013-2014,集团财务经理",@"2014-2015,项目部经理",@"2014-2015，高级策划师"];
        
        cell.imageView.image=[UIImage imageNamed:@"头像1"];
        cell.textLabel.text =arr[indexPath.row];
        cell.detailTextLabel.text =arr2[indexPath.row];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 20;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 0;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 50;
    }else{
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    UILabel *lable;
    if (section==1) {
        view.frame=CGRectMake(0, 0, WinWidth, 30);
         lable=[[UILabel alloc] init];
        lable.frame = CGRectMake(20, 5, WinWidth-20, 25);
        lable.backgroundColor=[UIColor clearColor];
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=@"工作经历";
        lable.textColor = [UIColor blackColor];
        lable.font  =[UIFont systemFontOfSize:15.0];
        [view addSubview:lable];
    }
    return view;
}

@end
