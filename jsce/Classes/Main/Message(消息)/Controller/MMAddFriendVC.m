//
//  MMAddFriendVC.m
//  jsce
//
//  Created by mac on 15/10/10.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMAddFriendVC.h"
#import "BaseTableViewCell.h"
#import "CustomSearchController.h"
#import "MMContactCell.h"
#import "ICPersonalInfoVC.h"
#import "MMApplyFriendViewController.h"
#import "InvitationManager.h"
#import "UIImage+Name.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface MMAddFriendVC ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>{
    NSArray *picArr;
    NSArray *titleArr;
    UITableViewController *searchTableVC;
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation MMAddFriendVC
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加朋友";
    self.showBackBtn  = YES;
    
    picArr = @[@"home_menu_scan_normal",@"icon_local_contact"];
    titleArr = @[@"名片扫一扫",@"手机联系人"];
    
    [self setUpSearchController];
    
    [self setUpTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSearchController{
    
    searchTableVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchTableVC.tableView.delegate=self;
    searchTableVC.tableView.dataSource=self;
    searchTableVC.tableView.tableFooterView = [[UIView alloc]  initWithFrame:CGRectZero];
   // [searchTableVC.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _searchController = [[CustomSearchController alloc] initWithSearchResultsController:searchTableVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate  = self;
    
    
    [self.searchController.searchBar sizeToFit];
    
    self.searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
    
    self.searchController.searchBar.placeholder = @"搜索";

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

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource   = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView]) {
        return 4;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *identifier = @"cell";

    if ([tableView isEqual:self.tableView]) {
        BaseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell =  [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row==0) {
            
            [cell.contentView addSubview:self.searchController.searchBar];
            
        }else if(indexPath.row ==1){
            
            UILabel *lable =[[UILabel alloc] init];
            lable.textColor = [UIColor grayColor];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.font = [UIFont systemFontOfSize:14.0];
            lable.text = @"我的名片";
            
            CGSize lableSize = [self sizeWithText:lable.text font:lable.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            lable.frame = CGRectMake((WinWidth-(lableSize.width+34+5))/2, (55-lableSize.height)/2,lableSize.width , lableSize.height);
            
            UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_head"]];
            imgView.frame  = CGRectMake(lable.frame.origin.x+lableSize.width+5, (55-34)/2, 34, 34);
            [cell.contentView addSubview:lable];
            [cell.contentView addSubview:imgView];
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.headImgView.image =[UIImage imageNamed:picArr[indexPath.row-2]] ;
            cell.textLabel.text = titleArr[indexPath.row-2];
        }
        return cell;

    }else{
        MMContactCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell =  [[MMContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.headImageView.image = [UIImage imageWithView: [self.dataSource objectAtIndex:indexPath.row]];
        cell.nameLable.text = [self.dataSource objectAtIndex:indexPath.row];
        cell.detailLable.text=@"北京公司";
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-80, (55-35)/2, 60, 35)];
    
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn  setBackgroundColor:NAVBAR_COLOR];
        [btn addTarget:self action:@selector(segueForPersonalVC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.tableView]) {
        if(indexPath.row==0){
            return self.searchController.searchBar.frame.size.height;
        }
    }

    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView]) {
        
    }else {
   
        NSString *buddyName = self.dataSource[indexPath.row];
        if ([self didBuddyExist:buddyName]) {
//            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeat", @"'%@'has been your friend!"), buddyName];
//            
//            [EMAlertView showAlertWithTitle:message
//                                    message:nil
//                            completionBlock:nil
//                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                          otherButtonTitles:nil];
            
        }
        else if([self hasSendBuddyRequest:buddyName])
        {
//            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.repeatApply", @"you have send fridend request to '%@'!"), buddyName];
//            [EMAlertView showAlertWithTitle:message
//                                    message:nil
//                            completionBlock:nil
//                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                          otherButtonTitles:nil];
            
        }else{
            ICPersonalInfoVC *icPIVC= [[ICPersonalInfoVC alloc] init];
            
            ICMessageBody *message = [[ICMessageBody alloc] init];
            message.posterName = self.dataSource[indexPath.row];
            icPIVC.messageBody = message;
            
            [self.searchController dismissViewControllerAnimated:NO completion:^{
                [self.navigationController pushViewController:icPIVC animated:YES];
            }];
        }
        
        
    }
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

//添加好友按钮的点击事件
- (void)segueForPersonalVC:(UIButton *)btn{
    [self.searchController.searchBar endEditing:YES];
    
    MMContactCell *cell = (MMContactCell *)btn.superview;
    
    NSIndexPath *indexPath = [searchTableVC.tableView indexPathForCell:cell];
    
    ICPersonalInfoVC *icPIVC= [[ICPersonalInfoVC alloc] init];
    
    ICMessageBody *message = [[ICMessageBody alloc] init];
    message.posterName = self.dataSource[indexPath.row];
    icPIVC.messageBody = message;
    
    [self.searchController dismissViewControllerAnimated:NO completion:^{
        [self.navigationController pushViewController:icPIVC animated:YES];
    }];
    
    
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (BOOL)hasSendBuddyRequest:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState == eEMBuddyFollowState_NotFollowed &&
            buddy.isPendingApproval) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)didBuddyExist:(NSString *)buddyName
{
    NSArray *buddyList = [[[EaseMob sharedInstance] chatManager] buddyList];
    for (EMBuddy *buddy in buddyList) {
    
        if ([buddy.username isEqualToString:buddyName] &&
            buddy.followState != eEMBuddyFollowState_NotFollowed) {
            return YES;
        }
    }
    return NO;
}

- (void)showMessageAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"说点啥子吧"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString=searchController.searchBar.text;
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if ([searchString isEqualToString:loginUsername]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    //判断是否已发来申请
    NSArray *applyArray = [[MMApplyFriendViewController shareController] dataSource];
    if (applyArray && [applyArray count] > 0) {
        for (ApplyEntity *entity in applyArray) {
            ApplyStyle style = [entity.style intValue];
            BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
            if (!isGroup && [entity.applicantUsername isEqualToString:searchString]) {
                NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", searchString];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
    }
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:searchString];
    [searchTableVC.tableView reloadData];

}
@end
