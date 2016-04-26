//
//  DiscoverMainVC.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "DiscoverMainVC.h"
#import "DCQueryViewController.h"
#import "DCLawViewController.h"
#import "DCSpecificationViewController.h"
#import "BaseTableViewCell.h"
@interface DiscoverMainVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableView;


@end

@implementation DiscoverMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发现";
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces=NO;
    [self.view addSubview:self.tableView];
    
}

#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 2.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    BaseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
   // cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        
        cell.headImgView.image=[UIImage imageNamed:@"jiagedongtai"];
        cell.textLabel.text =@"材料价格动态";
        
    }else{
        
        NSArray *imageArr=@[@"falvfagui",@"biaozhunguifan"];
        NSArray *titleArr=@[@"法律法规",@"标准规范"];
        cell.headImgView.image=[UIImage imageNamed:imageArr[indexPath.row]];
        cell.textLabel.text =titleArr[indexPath.row];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DCQueryViewController *dcqVC=[[DCQueryViewController alloc] init];
        dcqVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dcqVC animated:YES];
    }else{
        if (indexPath.row==0) {
            DCLawViewController *dclVC=[[DCLawViewController alloc] init];
            dclVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dclVC animated:YES];
        }else{
            DCSpecificationViewController *dcsVC=[[DCSpecificationViewController alloc] init];
            dcsVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:dcsVC animated:YES];
        }
    }
}

@end
