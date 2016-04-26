//
//  MMApplyFriendViewController.m
//  jsce
//
//  Created by mac on 15/10/13.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMApplyFriendViewController.h"
#import "JsceBaseTableView.h"
#import "MMApplyCell.h"
#import "InvitationManager.h"
#import "MMApplyDetailViewController.h"
#import "UIImage+Name.h"
#import "UserProfileManager.h"

static MMApplyFriendViewController *controller = nil;
@interface MMApplyFriendViewController ()<UITableViewDataSource,UITableViewDelegate,ApplyFriendCellDelegate>
@property(nonatomic,strong)JsceBaseTableView *tableView;

@end

@implementation MMApplyFriendViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource  =[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    
    return controller;
}

- (NSString *)loginUsername
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    return [loginInfo objectForKey:kSDKUsername];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新朋友";
    self.showBackBtn=YES;
    [self addRightBtn];
    [self setUpTableView];
     [self loadDataSourceFromLocalDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)addRightBtn{
    [self actionCustomRightBtnWithNrlImage:@"" htlImage:nil title:nil action:^{
        
    }];
}

- (void)setUpTableView{
    self.tableView = [[JsceBaseTableView alloc] init];
    self.tableView.delegate =self;
    self.tableView.dataSource  =self;
    self.tableView.tableFooterView = [[UIView alloc]  initWithFrame:CGRectZero];
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    
    [self loadDataSourceFromLocalDB];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MMApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell  = [[MMApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.dataSource.count > indexPath.row)
    {
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        if (entity) {
            cell.indexPath = indexPath;
            ApplyStyle applyStyle = [entity.style intValue];
            if (applyStyle == ApplyStyleGroupInvitation) {
                cell.titleLabel.text = @"群组通知";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if (applyStyle == ApplyStyleJoinGroup)
            {
                cell.titleLabel.text = @"群组通知";
                cell.headerImageView.image = [UIImage imageNamed:@"groupPrivateHeader"];
            }
            else if(applyStyle == ApplyStyleFriend){
                cell.titleLabel.text = entity.applicantUsername;
                cell.headerImageView.image = entity.image;
            }
            cell.contentLabel.text = entity.reason;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    return [MMApplyCell heightWithContent:entity.reason];
}


//点击进入详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MMApplyDetailViewController *mmADVC = [[MMApplyDetailViewController alloc] init];
     ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    mmADVC.applyEntity   =entity;
    [self.navigationController pushViewController:mmADVC animated:YES];
}

#pragma mark - ApplyFriendCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        [self showHudInView:self.view hint:@"正在发送申请..."];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        ApplyStyle applyStyle = [entity.style intValue];
        EMError *error;
        
        if (applyStyle == ApplyStyleJoinGroup)
         {
             [[EaseMob sharedInstance].chatManager acceptApplyJoinGroup:entity.groupId groupname:entity.groupSubject applicant:entity.applicantUsername error:&error];
         }
         else if(applyStyle == ApplyStyleFriend){
             [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
         }
        
        [self hideHud];
        if (!error) {
            [self.dataSource removeObject:entity];
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            
            if(applyStyle == ApplyStyleFriend){
            UserProfileEntity *user = [[UserProfileEntity alloc] init];
            user.username = entity.applicantUsername;
            user.image =entity.image;
            
            [[UserProfileManager sharedInstance] addMember:user loginUser:loginUsername];
            }
            
            [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
            [self.tableView reloadData];
        }
        else{
            [self showHint:@"接受失败"];
        }
    }
}


#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{
    if (dictionary && [dictionary count] > 0) {
        NSString *applyUsername = [dictionary objectForKey:@"username"];
        ApplyStyle style = [[dictionary objectForKey:@"applyStyle"] intValue];
        
        if (applyUsername && applyUsername.length > 0) {
            for (int i = ((int)[_dataSource count] - 1); i >= 0; i--) {
                ApplyEntity *oldEntity = [_dataSource objectAtIndex:i];
                ApplyStyle oldStyle = [oldEntity.style intValue];
                if (oldStyle == style && [applyUsername isEqualToString:oldEntity.applicantUsername]) {
                    if(style != ApplyStyleFriend)
                    {
                        NSString *newGroupid = [dictionary objectForKey:@"groupname"];
                        if (newGroupid || [newGroupid length] > 0 || [newGroupid isEqualToString:oldEntity.groupId]) {
                            break;
                        }
                    }
                    
                    oldEntity.reason = [dictionary objectForKey:@"applyMessage"];
                    [_dataSource removeObject:oldEntity];
                    [_dataSource insertObject:oldEntity atIndex:0];
                    [self.tableView reloadData];
                    
                    return;
                }
            }
            
            //new apply
            ApplyEntity * newEntity= [[ApplyEntity alloc] init];
            newEntity.applicantUsername = [dictionary objectForKey:@"username"];
            newEntity.style = [dictionary objectForKey:@"applyStyle"];
            newEntity.reason = [dictionary objectForKey:@"applyMessage"];
            newEntity.image = [UIImage imageWithView:[[dictionary objectForKey:@"username"] substringToIndex:1].uppercaseString];
            
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginName = [loginInfo objectForKey:kSDKUsername];
            newEntity.receiverUsername = loginName;
            
            NSString *groupId = [dictionary objectForKey:@"groupId"];
            newEntity.groupId = (groupId && groupId.length > 0) ? groupId : @"";
            
            NSString *groupSubject = [dictionary objectForKey:@"groupname"];
            newEntity.groupSubject = (groupSubject && groupSubject.length > 0) ? groupSubject : @"";
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] addInvitation:newEntity loginUser:loginUsername];
            
            [_dataSource insertObject:newEntity atIndex:0];
            [self.tableView reloadData];
            
        }
    }
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [self.dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}
@end
