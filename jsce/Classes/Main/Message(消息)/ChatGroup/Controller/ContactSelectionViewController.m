//
//  ContactSelectionViewController.m
//  jsce
//
//  Created by mac on 15/10/20.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ContactSelectionViewController.h"
#import "MultiSelectItem.h"
#import "MultiSelectedPanel.h"
#import "MultiSelectTableViewCell.h"
#import "ChineseToPinyin.h"
#import "UserProfileManager.h"
#import "MMChatViewController.h"
#import "UIImage+Name.h"
#import "GLGroupChatPicView.h"
#import "GroupImage.h"
@interface ContactSelectionViewController ()<UITableViewDataSource,UITableViewDelegate,MultiSelectedPanelDelegate>
@property (strong, nonatomic) UILocalizedIndexedCollation *indexCollation;//搜索核心
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MultiSelectedPanel *selectedPanel;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, strong) NSMutableArray *selectedIndexes; //记录选择项对应的路径

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) NSMutableArray *blockSelectedUsernames;//群组成员

@property (strong,nonatomic )   UIButton *sureButton;
@end

@implementation ContactSelectionViewController
- (NSMutableArray *)selectedItems{
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc] init];
    }
    return  _selectedItems;
}

- (NSMutableArray *)selectedIndexes{
    if (!_selectedIndexes) {
        _selectedIndexes = [[NSMutableArray alloc] init];
    }
    return  _selectedIndexes;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return  _dataSource;
}

- (NSMutableArray *)contactsSource{
    if (!_contactsSource) {
        _contactsSource = [[NSMutableArray alloc] init];
    }
    return  _contactsSource;
}

- (NSMutableArray *)sectionTitles{
    if (!_sectionTitles) {
        _sectionTitles = [[NSMutableArray alloc] init];
    }
    return  _sectionTitles;
}

- (instancetype)initWithBlockSelectedUsernames:(NSArray *)blockUsernames
{
    if (self= [super init]) {
        _blockSelectedUsernames = [NSMutableArray array];
        [_blockSelectedUsernames addObjectsFromArray:blockUsernames];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人";
  
    //建立索引的核心
    _indexCollation = [UILocalizedIndexedCollation currentCollation];

    
    [self setUpSearchControllerAndTableView];
    [self setUpButton];
    
    [self reloadDataSource];
    

 

    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpButton{
    [self actionCustomLeftBtnWithNrlImage:nil htlImage:nil title:@"取消" action:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -18;
    
    self.sureButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.sureButton.titleLabel.textAlignment= NSTextAlignmentRight;
    self.sureButton.enabled=NO;
     [self.sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(joinGroupChat:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sureButton];
    
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarButtonItem ];
    
    
    
}

#pragma mark 此处新建群组或者添加群成员
- (void)joinGroupChat:(UIButton *)btn{
    NSInteger maxUsersCount = 200;
    NSInteger count = self.selectedItems.count +self.blockSelectedUsernames.count;
    if (count> (maxUsersCount - 1)) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"群成员个数超了最大值了" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return ;
    }
    
     [self showHudInView:self.view hint:@"准备开始群聊..."];
    
    NSMutableArray *source = [NSMutableArray array];
    for (UserProfileEntity *item in self.selectedItems) {
        [source addObject:item.username];
    }
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc] init];
    setting.groupMaxUsersCount = maxUsersCount;
    
    setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *username = [loginInfo objectForKey:kSDKUsername];
    NSString *messageStr = [NSString stringWithFormat:@"%@ 邀请你加入群组", username];
    
    __weak ContactSelectionViewController *weakSelf = self;
    
    
    NSString *tempStr= [source componentsJoinedByString:@","];

    
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:tempStr description:nil invitees:source initialWelcomeMessage:messageStr styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        [weakSelf hideHud];
        if (group && !error) {
            [weakSelf hideHud];
           [self.navigationController popViewControllerAnimated:YES];
            
            GLGroupChatPicView *picView= [[GLGroupChatPicView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
            
            
            
            NSArray *nameArr = [[EaseMob sharedInstance].chatManager fetchOccupantList:group.groupId error:nil];
            
            NSArray *arr= [[UserProfileManager sharedInstance] contactListWithloginUser:username];
            
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            [arr  enumerateObjectsUsingBlock:^(UserProfileEntity *obj, NSUInteger idx, BOOL * stop) {
                
                for (NSString *str in nameArr) {
                    if ([obj.username isEqualToString:str]) {
                        [tempArr addObject:obj];
                    }
                }
                
            }];
            
            picView.totalEntries=tempArr.count;
            for (int i=0; i<tempArr.count; i++) {
                UserProfileEntity *entity = tempArr[i];
                [picView addImage:entity.image withInitials:nil];
            }
            [picView updateLayout];
            
            UIImage *groupImage=[self convertViewToImage:picView];
            
            GroupName *groupName = [[GroupName alloc] init];
            groupName.image = groupImage;
            groupName.groupId = group.groupId;
            
            [[GroupImage sharedInstance] addGroup:groupName  loginUser:username];
            
            
            MMChatViewController *chatController = [[MMChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
            chatController.title = group.groupSubject;
      
            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }
        else{
            [weakSelf showHint:@"创建群组失败，请重新操作"];
        }
    } onQueue:nil];
    
//   [[EaseMob sharedInstance].chatManager   asyncCreateGroupWithSubject:tempStr description:nil invitees:source initialWelcomeMessage:messageStr styleSetting:setting];
    //[self dismissViewControllerAnimated:YES completion:nil];
   
}

-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//配置搜索栏 和 TableView
- (void)setUpSearchControllerAndTableView{
    _selectedPanel = [[MultiSelectedPanel alloc ] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _selectedPanel.delegate = self;
    
     self.selectedPanel.selectedItems = self.selectedItems;
    [self.view addSubview:self.selectedPanel];
   //    self.selectedPanel.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44-BARHEIGHT)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier  = @"cell";
    MultiSelectTableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MultiSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserProfileEntity *item =[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  
    cell.headImageView.image = item.image;
    cell.nameLable.text = item.username;
    cell.detailLable.text=@"北京公司";
    
    if (item.disabled) {
        cell.selectState = MultiSelectTableViewSelectStateDisabled;
    }else{
        cell.selectState = item.selected?MultiSelectTableViewSelectStateSelected:MultiSelectTableViewSelectStateNoSelected;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    
    return 22;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([[self.dataSource objectAtIndex:section] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 22.0)];
    [contentView setBackgroundColor:[UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.sectionTitles objectAtIndex:section]];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:14.0];
    [contentView addSubview:label];
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UserProfileEntity *item= [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (item.disabled) {
        return;
    }
    item.selected = !item.selected;
   // [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView reloadData];
    if (item.selected) {
        //告诉panel应该添加
        [self.selectedItems addObject:item];
        [self.selectedIndexes addObject:indexPath];
        
        [self.selectedPanel didAddSelectedIndex:self.selectedItems.count-1];
        
     
    }else{
        //告诉panel应该删除
        NSUInteger index = [self.selectedItems indexOfObject:item];
        
        [self.selectedItems removeObject:item];
        [self.selectedIndexes removeObject:indexPath];
        
        if (index!=NSNotFound) {
            [self.selectedPanel didDeleteSelectedIndex:index];
            

        }
    }
    
    return;


    
}



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    [existTitles addObject:UITableViewIndexSearch];
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        if ([[self.dataSource objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

- (NSInteger)sectionForString:(NSString *)string
{
    if (string && string.length > 0) {
        return [_indexCollation sectionForObject:string collationStringSelector:@selector(uppercaseString)];
    }
    else{
        return -1;
    }
}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[_indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (UserProfileEntity *item in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:item.username];
        
        NSInteger section = [_indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:item];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(UserProfileEntity *obj1, UserProfileEntity *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - dataSource

- (void)reloadDataSource{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
//    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
//    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
//    for (EMBuddy *buddy in buddyList) {
//        if (![blockList containsObject:buddy.username]) {
//            MultiSelectItem *item = [[MultiSelectItem alloc] init];
//    
//            item.userName=buddy.username;
//            item.selected=NO;
//            item.disabled = NO;
//            [self.contactsSource addObject:item];
//        }
//    }
//    
//    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
//    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
//    if (loginUsername && loginUsername.length > 0) {
//        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
//        MultiSelectItem *item = [[MultiSelectItem alloc] init];
//
//        item.userName=loginBuddy.username;
//            item.selected=YES;
//        item.disabled = YES;
//
//        [self.contactsSource addObject:item];
//    }
    
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username]) {
            [self.contactsSource addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [self.contactsSource addObject:loginBuddy];
    }
    
    
    NSArray *tempArr  =   [[UserProfileManager sharedInstance] contactListWithloginUser:loginUsername];
    if (tempArr.count==0) {
        [self.contactsSource enumerateObjectsUsingBlock:^(EMBuddy *buddy, NSUInteger idx, BOOL *stop) {
            UserProfileEntity *user = [[UserProfileEntity alloc] init];
            user.username = buddy.username;
            user.image =[UIImage imageWithView:[[buddy.username substringToIndex:1] uppercaseString]];
            
            [[UserProfileManager sharedInstance] addMember:user  loginUser:loginUsername];
            
        }];
        
        tempArr = [[UserProfileManager sharedInstance] contactListWithloginUser:loginUsername];
    }else {
        
        
        
        [self.contactsSource enumerateObjectsUsingBlock:^(EMBuddy *buddy, NSUInteger idx, BOOL *stop) {
            NSInteger count=0;
            
            
            for (UserProfileEntity *entity in tempArr) {
                if ([entity.username isEqualToString:buddy.username]) {
                    count++;
                }
            }
            if (count==0) {
                UserProfileEntity *user1 = [[UserProfileEntity alloc] init];
                user1.username = buddy.username;
                user1.image =[UIImage imageWithView:[[buddy.username substringToIndex:1] uppercaseString]];
                [[UserProfileManager sharedInstance] addMember:user1  loginUser:loginUsername];
                
            }
            
        }];
        
        tempArr = [[UserProfileManager sharedInstance] contactListWithloginUser:loginUsername];
        
    }
    
    [tempArr enumerateObjectsUsingBlock:^(UserProfileEntity *user, NSUInteger idx, BOOL *stop) {
      
        if ([user.username isEqualToString:loginUsername]) {
            user.disabled=YES;
            user.selected=YES;
        }else{
            user.disabled=NO;
            user.selected=NO;
        }
        
    }];

    
    [self.dataSource addObjectsFromArray:[self sortDataArray:tempArr]];
    
    
    if ([_blockSelectedUsernames count] > 0) {
        for (NSString *username in _blockSelectedUsernames) {
            NSInteger section = [self sectionForString:username];
            NSMutableArray *tmpArray = [_dataSource objectAtIndex:section];
            if (tmpArray && [tmpArray count] > 0) {
                for (int i = 0; i < [tmpArray count]; i++) {
                    UserProfileEntity *item  = [tmpArray objectAtIndex:i];
                    if ([item.username isEqualToString:username]) {
                        item.selected=YES;
                        item.disabled=YES;
//                        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        
                        break;
                    }
                }
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - selelcted panel delegate
- (void)willDeleteRowWithItem:(UserProfileEntity *)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel
{
    //在此做对数组元素的删除工作
    NSUInteger index = [self.selectedItems indexOfObject:item];
    if (index==NSNotFound) {
        return;
    }
    
    item.selected = NO;
    
    
    [self.tableView reloadData];
    
    [self.selectedItems removeObjectAtIndex:index];
    [self.selectedIndexes removeObjectAtIndex:index];
}

- (void)updateConfirmButton{
    
    if (self.selectedItems.count) {
        NSString *str= [NSString stringWithFormat:@"确定(%li)",self.selectedItems.count];
        [self.sureButton setTitle:str forState:UIControlStateNormal];
        
        [self.sureButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.sureButton.enabled=YES;
    }else{
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
        [self.sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.sureButton.enabled=YES;

    }
    
}



@end
