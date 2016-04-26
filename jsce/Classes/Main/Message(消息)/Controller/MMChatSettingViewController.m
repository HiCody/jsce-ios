//
//  MMChatSettingViewController.m
//  jsce
//
//  Created by mac on 15/10/14.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatSettingViewController.h"
#import "JsceBaseTableView.h"
#import "MMContactCell.h"
@interface MMChatSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bottomView;
@end

@implementation MMChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"聊天设置";
    self.showBackBtn=YES;
     self.view.backgroundColor  = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, 40)];
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(deleteFriends) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"删除好友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius=5.0;
    btn.frame= CGRectMake(15, 0, screenWidth-2*15, 40);
    [_bottomView addSubview:btn];
    _bottomView.backgroundColor = [UIColor clearColor];


        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView  = _bottomView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces  =NO;
    [self.view addSubview:self.tableView];
    

}



- (void)deleteFriends{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"同时会将我从对方的列表中删除，且屏蔽对方的临时会话，不再接收此人的消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除好友" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    cell.selectionStyle=  UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.headImageView.image = [UIImage imageNamed:@"头像1"];
            cell.nameLable.text = @"张三";
            cell.detailLable.text =@"北京公司";
            
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;

            cell.imageView.image=[UIImage imageNamed:@"common_add_blue"];
            
            cell.textLabel.text=@"创建讨论组";
            cell.textLabel.textColor=NAVBAR_COLOR;
            cell.textLabel.font =[UIFont systemFontOfSize:16.0];
            cell.textLabel.frame=CGRectMake(cell.headImageView.frame.origin.x+cell.headImageView.frame.size.width+20, (44-18)/2, 150, 18);
        }

    }else{

        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        if (indexPath.row==0) {
            cell.textLabel.text = @"聊天记录";
        }else{
            cell.textLabel.text  =@"屏蔽此人";
        }

        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 55;
        }else{
            return 44;
        }
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 20;
    }
}

@end
