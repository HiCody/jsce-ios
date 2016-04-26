//
//  ChatGroupDetailViewController.m
//  jsce
//
//  Created by mac on 15/10/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ChatGroupDetailViewController.h"
#import "ChatGroupSubjectNameViewController.h"
#import "GroupHeaderView.h"
@interface ChatGroupDetailViewController ()<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate,UIActionSheetDelegate>
@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup *chatGroup;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic)UITableView *tableView;

@property (strong , nonatomic)UIView *bottomView;

@property (strong , nonatomic)GroupHeaderView *groupHeaderView;

@property (strong , nonatomic)NSMutableArray *blockUsernames;
@end

@implementation ChatGroupDetailViewController
- (NSMutableArray *)blockUsernames{
    if (_blockUsernames) {
        _blockUsernames = [[NSMutableArray alloc] init];
    }
    return _blockUsernames;
}

- (void)registerNotifications {
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications {
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)initWithGroup:(EMGroup *)chatGroup
{
    self = [super init];
    if (self) {
        // Custom initialization
        _chatGroup = chatGroup;
        _dataSource = [NSMutableArray array];
        _occupantType = GroupOccupantTypeMember;
        [self registerNotifications];
    }
    return self;
}

- (instancetype)initWithGroupId:(NSString *)chatGroupId
{
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:chatGroupId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:chatGroupId];
    }
    
    self = [self initWithGroup:chatGroup];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self titleStr];
    self.showBackBtn = YES;
    [self setUpTableView];
    
    [self fetchGroupInfo];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (NSString *)titleStr{
    NSString *title =[NSString stringWithFormat:@"聊天信息(%li)",self.chatGroup.groupOccupantsCount];
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-BARHEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource  = self;
    
    [self.view addSubview:self.tableView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screenWidth, 40)];
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(deleteAndBack) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"删除并退出" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius=5.0;
    btn.frame= CGRectMake(15, 0, screenWidth-2*15, 40);
    [_bottomView addSubview:btn];
    _bottomView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView  = _bottomView;
}

- (void)deleteAndBack{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"退出后不会通知群聊其他成员，且不会再接收此群聊消息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.tableView];
}

- (void)refreshCollectionView{
    int  num = self.dataSource.count%4;
    NSInteger count= 0;
    if (num==0) {
        count = self.dataSource.count/4;
    }else{
        count  = self.dataSource.count/4+1;
    }
    
    self.groupHeaderView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, count*90+20)];
    self.groupHeaderView.collectionView.frame = CGRectMake(0, 20, screenWidth, count*90);
    self.groupHeaderView.selectedItems = self.dataSource;
}

#pragma  mark UITableViewDataSource,UITableViewDelegate,
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if (section==1) {
        return 3;
    }else if (section==2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
 
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.accessoryType= UITableViewCellAccessoryNone;
            [self refreshCollectionView];
            [cell.contentView addSubview:self.groupHeaderView];
        }else{
        
            cell.textLabel.text =[NSString stringWithFormat:@"全部群成员(%li)",self.chatGroup.groupOccupantsCount] ;
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.accessoryType= UITableViewCellAccessoryNone;
            cell.textLabel.text =@"群组ID";
            cell.detailTextLabel.text=self.chatGroup.groupId;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        }else if (indexPath.row==1) {
            cell.textLabel.text =@"群聊名称";
            cell.detailTextLabel.text = self.chatGroup.groupSubject;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        }else if(indexPath.row==2){
            cell.textLabel.text =@"群公告";
        }
    }
    if (indexPath.section==2) {
         cell.accessoryType= UITableViewCellAccessoryNone;
        cell.textLabel.text =@"清空群聊记录";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
       
            int  num = self.dataSource.count%4;
            NSInteger count= 0;
            if (num==0) {
                count = self.dataSource.count/4;
            }else{
                count  = self.dataSource.count/4+1;
            }
            return count*90+20;
        }
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0.5;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            
        }
    }else if(indexPath.section==1){
        if (indexPath.row==1) {
            ChatGroupSubjectNameViewController *chatGSNVC=[[ChatGroupSubjectNameViewController alloc] initWithGroup:self.chatGroup];
            [self.navigationController pushViewController:chatGSNVC animated:YES];
        }
    }
}

- (void)fetchGroupInfo
{
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"加载数据..."];
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_chatGroup.groupId completion:^(EMGroup *group, EMError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                weakSelf.chatGroup = group;
                [weakSelf reloadDataSource];
            }
            else{
                [weakSelf showHint:@"获取群组详情失败，请稍后重试"];
            }
        });
    } onQueue:nil];
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    self.occupantType = GroupOccupantTypeMember;
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([self.chatGroup.owner isEqualToString:loginUsername]) {
        self.occupantType = GroupOccupantTypeOwner;
    }
    
    if (self.occupantType != GroupOccupantTypeOwner) {
        for (NSString *str in self.chatGroup.members) {
            if ([str isEqualToString:loginUsername]) {
                self.occupantType = GroupOccupantTypeMember;
                break;
            }
        }
    }
    
    [self.dataSource addObjectsFromArray:self.chatGroup.occupants];
    
    if (self.dataSource.count<200) {
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [self refreshCollectionView];
//        [self refreshFooterView];
        
        [self.tableView reloadData];
        [self hideHud];
    });
}

@end
