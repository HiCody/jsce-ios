//
//  MessageMainVC.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "MessageMainVC.h"
#import "MMMainwCell.h"
#import "MMAgencyMattersViewController.h"
#import "DXPopover.h"
#import "MMContactsViewController.h"
#import "XHPopMenu.h"
#import "MMAddFriendVC.h"
#import "MMApplyFriendViewController.h"
#import "NSDate+Category.h"
#import "MMChatListCell.h"
#import "MMChatViewController.h"
#import "ContactSelectionViewController.h"
#import "JsceNavigationController.h"
#import "GroupListViewController.h"
#import "UserProfileManager.h"
#import "ContactSelectionViewController.h"
#import "UIImage+Name.h"
#import "GLGroupChatPicView.h"
#import "GroupImage.h"  
@interface MessageMainVC ()<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate,ChatViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (nonatomic, strong) XHPopMenu *popMenu;

@property (nonatomic, strong) UIView *networkStateView;
@end

@implementation MessageMainVC
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息";
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];

    [self networkStateView];
    [self configTableView];
    [self configNaviButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"当前网络连接失败";
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}



- (void)configTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-112) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.bounces  =NO;
    [self.view addSubview:self.tableView];
    
}

- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i < 4; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"icon_contact_menu_add_friend";
                    title = @"添加朋友";
                    break;
                }
                case 1: {
                    imageName = @"icon_card";
                    title = @"扫一扫";
                    break;
                }
                case 2: {
                    imageName = @"icon_create_group";
                    title = @"发起群聊";
                    break;
                }
                case 3: {
                    imageName = @"icon_group";
                    title = @"我的群聊";
                    break;
                }
          
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        typeof(self) __weak weakSelf = self;
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
    
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 0) {
                MMAddFriendVC *addFVC  = [[MMAddFriendVC alloc] init];
                
                addFVC.hidesBottomBarWhenPushed = YES;
                
                [weakSelf.navigationController pushViewController:addFVC animated:YES];
                
            }else if (index == 1 ) {
               
            }else if (index == 2 ){
                ContactSelectionViewController  *contactSVC=[[ContactSelectionViewController alloc] initWithBlockSelectedUsernames:nil];
                JsceNavigationController *navi = [[JsceNavigationController alloc] initWithRootViewController:contactSVC];
                [weakSelf.navigationController presentViewController:navi animated:YES completion:nil];
            }else if (index == 3 ){
                GroupListViewController *groupListVC = [[GroupListViewController alloc] init];
                groupListVC.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:groupListVC animated:YES];
            }
        };
    }
    return _popMenu;
}


- (void)configNaviButton{
    [self actionCustomLeftBtnWithNrlImage:@"common_massage_contacts" htlImage:nil title:nil action:^{
        MMContactsViewController *mmCVC  = [[MMContactsViewController alloc] init];
        mmCVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mmCVC animated:YES];
    }];
    
    [self actionCustomRightBtnWithNrlImage:@"industal_ publish" htlImage:nil title:nil action:^{
         [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
    }];
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret =  @"[图片]";
            } break;
            case eMessageBodyType_Text:{
#pragma mark 表情
                // 表情映射。
//                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
//                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
        
                    ret = ((EMTextMessageBody *)messageBody).text;
              
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[语音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}


#pragma mark -UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.dataSource.count+1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *identifier = @"cell";
        MMMainwCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MMMainwCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        cell.arrowIndicator.hidden=NO;
        if (indexPath.section==0) {
            
            cell.imgView.image=[UIImage imageNamed:@"wait_todo_alter"];
            cell.middleTitleLable.text =@"待办事宜";
            cell.middleTitleLable.hidden=NO;
        }else{
            
            if ([[MMApplyFriendViewController shareController] dataSource].count) {
                cell.titileLable.text =@"通知";
                cell.detailLable.text=self.notificationTitle ;
                
                cell.imgView.image=[UIImage imageNamed:@"icon_local_contact"];
                
                cell.detailLable.hidden = NO;
                cell.titileLable.hidden = NO;
                cell.middleTitleLable.hidden=YES;
            }else{
                cell.imgView.image=[UIImage imageNamed:@"icon_local_contact"];
                cell.middleTitleLable.text=@"通知";
                cell.middleTitleLable.hidden=NO;
                cell.detailLable.hidden = YES;
                cell.titileLable.hidden = YES;
            }
 
        }
        return cell;
    }else {
        static NSString *identify = @"chatListCell";
        MMChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[MMChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row-1];
        cell.name = conversation.chatter;
        
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        
        if (conversation.conversationType == eConversationTypeChat) {
#pragma mark 此处可以获取头像
            
            
            NSArray *arr= [[UserProfileManager sharedInstance] contactListWithloginUser:loginUsername];
          
            
            [arr enumerateObjectsUsingBlock:^(UserProfileEntity *obj, NSUInteger idx, BOOL *stop) {
                
                if ([obj.username isEqualToString:conversation.chatter]) {
                    cell.imageView.image = obj.image;
                }

                
            }];
            
     
        }else{
            NSString *imageName = @"groupPublicHeader";
      
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        
                        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                        [ext setObject:group.groupSubject forKey:@"groupSubject"];
                        [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                        conversation.ext = ext;
                        
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
                            
                            cell.imageView.image  = groupImage;
                        }else{
                            cell.imageView.image  =  tempGroupName.image;
                        }
  

                        break;
                    }
                }

            cell.placeholderImage = [UIImage imageNamed:imageName];
        }
        cell.detailMsg = [self subTitleMessageByConversation:conversation];
        cell.time = [self lastMessageTimeByConversation:conversation];
        cell.unreadCount = [self unreadMessageCountByConversation:conversation];

         return cell;
    }
    
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
    return 65;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        MMAgencyMattersViewController *mmamVC=[[MMAgencyMattersViewController alloc] init];
        mmamVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mmamVC animated:YES];
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            
            MMApplyFriendViewController *afVC=[MMApplyFriendViewController shareController];
            afVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:afVC animated:YES];
            
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row-1];
            
            MMChatViewController *chatController;
            NSString *title = conversation.chatter;
            if (conversation.conversationType != eConversationTypeChat) {
                if ([[conversation.ext objectForKey:@"groupSubject"] length])
                {
                    title = [conversation.ext objectForKey:@"groupSubject"];
                }
                else
                {
                    NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                    for (EMGroup *group in groupArray) {
                        if ([group.groupId isEqualToString:conversation.chatter]) {
                            title = group.groupSubject;
                            break;
                        }
                    }
                }
            }else if (conversation.conversationType == eConversationTypeChat) {
                title = [[UserProfileManager sharedInstance] getNickNameWithUsername:conversation.chatter];
            }
            
            NSString *chatter = conversation.chatter;
            chatController = [[MMChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
            chatController.delelgate = self;
            chatController.title = title;
            chatController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
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

#pragma mark - action

- (void)reloadApplyView
{
    NSInteger count = [[[MMApplyFriendViewController shareController] dataSource] count];
    
        if (count == 0) {
   //         self.unapplyCountLabel.hidden = YES;
              [self.tableView reloadData];
        }
        else
        {
//            NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)count];
//            CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
//            CGRect rect = self.unapplyCountLabel.frame;
//            rect.size.width = size.width > 20 ? size.width : 20;
//            self.unapplyCountLabel.text = tmpStr;
//            self.unapplyCountLabel.frame = rect;
//            self.unapplyCountLabel.hidden = NO;
            [self.tableView reloadData];
            
        }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row>0) {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        if (indexPath.row>0) {
            if (editingStyle == UITableViewCellEditingStyleDelete) {
                EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row-1];
                [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO append2Chat:YES];
                [self.dataSource removeObjectAtIndex:indexPath.row-1];
             
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }

        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark - IChatMangerDelegate

- (void)group:(EMGroup *)group didCreateWithError:(EMError *)error{
    if (!error) {
        ContactSelectionViewController *csvc= [[ContactSelectionViewController alloc] init];
       [csvc.navigationController dismissViewControllerAnimated:YES completion:nil];
        [csvc hideHud];
        MMChatViewController *chatController = [[MMChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
        chatController.title = group.groupSubject;
      [self.navigationController pushViewController:chatController animated:YES];
    }else{
         [self showHint:@"创建群组失败，请重新操作"];
    }

}

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(@"开始接收离线消息");
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(@"离线消息接收成功");
}


@end
