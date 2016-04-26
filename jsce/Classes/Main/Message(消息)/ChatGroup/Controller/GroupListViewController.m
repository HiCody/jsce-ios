//
//  GroupListViewController.m
//  jsce
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "GroupListViewController.h"
#import "BaseTableViewCell.h"
#import "MMChatViewController.h"
#import "GLGroupChatPicView.h"
#import "GroupImage.h"
#import "UserProfileManager.h"
@interface GroupListViewController ()<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic,strong )UITableView *tableView;
@end

@implementation GroupListViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群聊";
    self.showBackBtn=YES;
    
    [self setUpTableView];
    
#warning 把self注册为SDK的delegate
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [self reloadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpTableView{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-BARHEIGHT)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self.view addSubview:self.tableView];
}

#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EaseMob sharedInstance].chatManager groupList];
    [self.dataSource addObjectsFromArray:rooms];
    
    [self.tableView reloadData];
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error) {
        [self reloadDataSource];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - Table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    if (group.groupSubject && group.groupSubject.length > 0) {
        cell.textLabel.text = group.groupSubject;
    }
    else {
        cell.textLabel.text = group.groupId;
    }
    cell.detailTextLabel.text=[NSString stringWithFormat:@"(%li人)",group.groupOccupantsCount];
    cell.detailTextLabel.textAlignment=NSTextAlignmentRight;
    cell.detailTextLabel.font= [UIFont systemFontOfSize:14.0];
    
//    GLGroupChatPicView *picView= [[GLGroupChatPicView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
//    NSArray *nameArr = [[EaseMob sharedInstance].chatManager fetchOccupantList:group.groupId error:nil];;
//    
//    picView.totalEntries=nameArr.count;
//    for (int i=0; i<nameArr.count; i++) {
//        [picView addImage:nil withInitials:nameArr[i]];
//    }
//    [picView updateLayout];
//    
//    cell.headImgView.image = [self convertViewToImage:picView] ;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    
    NSInteger count = 0;
    NSArray *groupImageArr =  [[GroupImage sharedInstance] groupWithloginUser:loginUsername];
    
    GroupName *tempGroupName;
    for (GroupName *groupName in groupImageArr) {
        if ([groupName.groupId isEqualToString:group.groupId]) {
            count++;
            tempGroupName = groupName;
            break;
        }
    }
    
    if (count==0) {
        GLGroupChatPicView *picView= [[GLGroupChatPicView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        
        
        
        NSArray *nameArr =  [[EaseMob sharedInstance].chatManager fetchOccupantList:group.groupId error:nil];
        
//        NSArray *arr= [[UserProfileManager sharedInstance] contactListWithloginUser:loginUsername];
//        
//        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
//        [arr  enumerateObjectsUsingBlock:^(UserProfileEntity *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            for (NSString *str in nameArr) {
//                if ([obj.username isEqualToString:str]) {
//                    [tempArr addObject:obj];
//                }
//            }
//            
//        }];
        
        picView.totalEntries=nameArr.count;
        for (int i=0; i<nameArr.count; i++) {
            
            [picView addImage:nil withInitials:nameArr[i]];
        }
        [picView updateLayout];
        
        UIImage *groupImage=[self convertViewToImage:picView];
        
        GroupName *groupName = [[GroupName alloc] init];
        groupName.image = groupImage;
        groupName.groupId = group.groupId;
        
        [[GroupImage sharedInstance] addGroup:groupName  loginUser:loginUsername];
        
        cell.headImgView.image  = groupImage;
    }else{
        cell.headImgView.image  =  tempGroupName.image;
    }
    

    
    return cell;
}


-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    MMChatViewController *chatController = [[MMChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
    chatController.title = group.groupSubject;
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
