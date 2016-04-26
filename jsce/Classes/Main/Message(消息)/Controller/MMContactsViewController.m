//
//  MMContactsViewController.m
//  jsce
//
//  Created by mac on 15/10/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMContactsViewController.h"
#import "CustomSearchController.h"
#import "ChineseToPinyin.h"
#import "MMContactCell.h"
#import "MMApplyFriendViewController.h"
#import "MMChatViewController.h"
#import "UserProfileManager.h"
#import "UIImage+Name.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface MMContactsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@end

@implementation MMContactsViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    self.showBackBtn=YES;
    
 
    [self setUpSearchControllerAndTableView];
    
    [self reloadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//配置搜索栏 和 TableView
- (void)setUpSearchControllerAndTableView{

    _searchController = [[CustomSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate  = self;
    
    
    [self.searchController.searchBar sizeToFit];

    self.searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
    
    self.searchController.searchBar.placeholder = @"搜索";
    
    [self.view addSubview:self.searchController.searchBar];
    
    self.definesPresentationContext = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchController.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.searchController.searchBar.frame.size.height -BARHEIGHT)];
    
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
    MMContactCell  *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MMContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserProfileEntity *entity = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.headImageView.image = entity.image;
    cell.nameLable.text = entity.username;
    cell.detailLable.text=@"北京公司";

    
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
   
 
        UserProfileEntity *entity = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:entity.username]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你不能和自己聊" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        MMChatViewController  *chatVC = [[MMChatViewController alloc] initWithChatter:entity.username isGroup:NO];
        chatVC.title = [[UserProfileManager sharedInstance] getNickNameWithUsername:entity.username];
        [self.navigationController pushViewController:chatVC animated:YES];
   
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


#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (UserProfileEntity *entity in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:entity.username];
        
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:entity];
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
        
      
        
        [self.contactsSource enumerateObjectsUsingBlock:^(EMBuddy *buddy, NSUInteger idx, BOOL * stop) {
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
    
    
    
    [self.dataSource addObjectsFromArray:[self sortDataArray:tempArr]];
    
    [_tableView reloadData];
}


@end
