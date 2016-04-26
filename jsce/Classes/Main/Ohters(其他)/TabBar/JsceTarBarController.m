//
//  JsceTarBarController.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "JsceTarBarController.h"
#import "IndustryCircleMainVC.h"
#import "MessageMainVC.h"   
#import "DiscoverMainVC.h"
#import "OfficialBussinessMainVC.h"
#import "JsceNavigationController.h"
#import "MMContactsViewController.h"
#import "NSDate+Category.h"
#import "EMCDDeviceManager.h"
#import "UserProfileManager.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface JsceTarBarController () <UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate>
@property(nonatomic,strong)MMContactsViewController *contactsVC;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property(nonatomic,strong) MessageMainVC *messageMainVC;
@end

@implementation JsceTarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contactsVC= [[MMContactsViewController  alloc] init];;

  

   
    [self registerNotifications];
    
    [self setupSubviews];

}


- (void)dealloc
{
    [self unregisterNotifications];
}

#pragma mark - private


-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)setupSubviews{
    IndustryCircleMainVC *icVC = [[IndustryCircleMainVC alloc] init];
    JsceNavigationController *icNav = [[JsceNavigationController alloc] initWithRootViewController:icVC];
    
    self.messageMainVC = [[MessageMainVC alloc] init];
    JsceNavigationController *mmNav = [[JsceNavigationController alloc] initWithRootViewController:self.messageMainVC];
    
    DiscoverMainVC *dmVC = [[DiscoverMainVC alloc] init];
    JsceNavigationController *dmNav = [[JsceNavigationController alloc] initWithRootViewController:dmVC];
    
    OfficialBussinessMainVC *obmVC = [[OfficialBussinessMainVC alloc] init];
    JsceNavigationController *obmNav = [[JsceNavigationController alloc] initWithRootViewController:obmVC];
    
    self.viewControllers=@[icNav,mmNav,dmNav,obmNav];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    UITabBar *tabBar=self.tabBar;
    
    
    UITabBarItem *item1=[tabBar.items objectAtIndex:0];
    UITabBarItem *item2=[tabBar.items objectAtIndex:1];
    UITabBarItem *item3=[tabBar.items objectAtIndex:2];
    UITabBarItem *item4=[tabBar.items objectAtIndex:3];
    
    [item1 setTitle:@"行业圈"];
    
    [item1 setImage:[[UIImage imageNamed:@"unselect_industry_circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"select_industry_circle"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [item2 setTitle:@"消息"];
    [item2 setImage:[[UIImage imageNamed:@"unselected_mes_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"selected_mes_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item3 setTitle:@"发现"];
    [item3 setImage:[[UIImage imageNamed:@"unselected_find_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"selected_find_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [item4 setTitle:@"办公"];
    [item4 setImage:[UIImage imageNamed:@"unselected_work_icon"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"selected_work_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

}

#pragma mark - IChatManagerDelegate 消息变化

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR

        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:@"有透传消息"];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"图片";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"位置";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"声音";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"视频";
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction =@"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}


#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = @"你的账号登录失败，正在重试中... \n点击 '登出' 按钮跳转到登录页面 \n点击 '继续等待' 按钮等待重连成功";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:@"继续等待"
                                                  otherButtonTitles:@"登出",
                                  nil];
        alertView.tag = 99;
        [alertView show];
      //  [_chatListVC isConnect:NO];
    }
}


#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号在其他地方登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号已从服务端移除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{

        [self hideHud];
        [self showHint:@"正在重连中..."];

    
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{

        [self hideHud];
        if (error) {
            [self showHint:@"重连失败，稍候将继续重连"];
        }else{
            [self showHint:@" 重连成功！"];
        }
 
    
}

#pragma mark - IChatManagerDelegate 好友变化
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    NSString *str = [NSString stringWithFormat:@"%@请求添加好友",username];
   
    
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:@"%@ 添加你为好友", username];
        notification.alertAction = @"打开";
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif

    
     self.messageMainVC.notificationTitle=str;
    
    [self.messageMainVC reloadApplyView];
    
 
 
}



- (void)didAcceptedByBuddy:(NSString *)username
{
    [_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    
    NSString *message = [NSString stringWithFormat:@"%@拒绝添加你为好友", username];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
   
    [alertView show];
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    [_contactsVC reloadDataSource];
}



#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == 99) {
//        if (buttonIndex != [alertView cancelButtonIndex]) {
//            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//                [[ApplyViewController shareController] clear];
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//            } onQueue:nil];
//        }
//    }
    if (alertView.tag == 100) {

        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
    } else if (alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
   // [_chatListVC networkChanged:connectionState];
}
@end
