//
//  MMChatViewController.m
//  jsce
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMChatViewController.h"
#import "MMChatSettingViewController.h"
#import "MMMessageToolBar.h"
#import "MMChatBarMoreView.h"
#import "MMRecordView.h"
#import  <AVFoundation/AVFoundation.h>
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
#import "MMChatViewCell.h"
#import "MMChatTimeCell.h"
#import "NSDate+Category.h"
#import "MMMessageModel.h"
#import "MessageModelManager.h"
#import "UserProfileManager.h"
#import "ChatSendHelper.h"
#import "ChatGroupDetailViewController.h"
#import "MessageMainVC.h"
#import "UIImage+Name.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define KPageCount 20
#define KHintAdjustY    50
@interface MMChatViewController ()<UITableViewDataSource,UITableViewDelegate,MessageToolBarDelegate,ChatBarMoreViewDelegate,EMCDDeviceManagerDelegate,IChatManagerDelegate,EMCallManagerDelegate>{
     dispatch_queue_t _messageQueue;
}
@property (nonatomic) BOOL isChatGroup;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MMMessageToolBar *chatToolBar;

@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic,assign) BOOL isPlayingAudio;
@property (nonatomic,assign) BOOL isScrollToBottom;
@property (nonatomic,strong)UIImagePickerController *imagePicker;

@end

@implementation MMChatViewController

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    EMConversationType type = isGroup ? eConversationTypeGroupChat : eConversationTypeChat;
    self = [self initWithChatter:chatter conversationType:type];
    if (self) {
    }
    
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {

        _isPlayingAudio = NO;
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}

- (BOOL)isChatGroup
{
    return _conversationType != eConversationTypeChat;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:234/255.0f blue:234/255.f alpha:1.0f];
    self.showBackBtn = YES;
    [self addRightBtn];
    
#warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    // 注册为Call的Delegate
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    _messageQueue = dispatch_queue_create("jsce", NULL);
    _isScrollToBottom = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.tableView addGestureRecognizer:tap];
    [self.view addSubview:self.tableView];
 
    [self.view addSubview:self.chatToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[MMChatBarMoreView class]]) {
        [(MMChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO];
    
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isInvisible = YES;
    }
    else
    {
        //结束call
        self.isInvisible = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    if (_isScrollToBottom) {
        [self scrollViewToBottom:NO];
    }
    else{
        _isScrollToBottom = YES;
    }
    
    self.isInvisible = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    self.isInvisible = YES;
}

- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

- (void)dealloc
{

    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];


}


//跳转到聊天设置
- (void)addRightBtn{
    
    if (self.isChatGroup) {
        
        [self actionCustomRightBtnWithNrlImage:@"to_group_details_normal" htlImage:nil title:nil action:^{
            
            ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_chatter];
            [self.navigationController pushViewController:detailController animated:YES];

        }];
        
    }else{
        
        [self actionCustomRightBtnWithNrlImage:@"header_right_my" htlImage:nil title:nil action:^{
            MMChatSettingViewController *chatSettingVC= [[MMChatSettingViewController alloc] init];
            
            [self.navigationController pushViewController:chatSettingVC animated:YES];
        }];
        
    }

    
    [self actionCustomLeftBtnWithNrlImage:@"login_back" htlImage:nil title:nil action:^{
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [_conversation latestMessage];
        if (message == nil) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO append2Chat:YES];
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - getter
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=RGB(235, 235, 235);
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (MMMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[MMMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [MMMessageToolBar defaultHeight], self.view.frame.size.width, [MMMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = self.isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[MMChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) type:type];
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _chatToolBar;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            MMChatTimeCell *timeCell = (MMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[MMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{
            MMMessageModel *model = (MMMessageModel *)obj;
            NSString *cellIdentifier = [MMChatViewCell cellIdentifierForMessageModel:model];
            MMChatViewCell *cell = (MMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[MMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            
           cell.headImageView.image = model.headImage;
            return cell;
        }
   }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
//       return [tableView fd_heightForCellWithIdentifier:[MMChatViewCell cellIdentifierForMessageModel:(MMMessageModel *)obj] cacheByIndexPath:indexPath configuration:^(MMChatViewCell *cell) {
//           MMMessageModel *model = (MMMessageModel *)obj;
//           cell.messageModel = model;
//            
//        }];

        
        return [MMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MMMessageModel *)obj];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
}

#pragma mark - IChatManagerDelegate
//发送消息后的回调
-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MMMessageModel class]])
         {
             MMMessageModel *model = (MMMessageModel*)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

// 收到"已读回执"时的回调方法
- (void)didReceiveHasReadResponse:(EMReceipt*)receipt
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MMMessageModel class]])
         {
             MMMessageModel *model = (MMMessageModel*)obj;
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak MMChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MMMessageModel class]]) {
                    MMMessageModel *model = (MMMessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MMMessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        if ([self->_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                            NSString *showName = [self->_delelgate nickNameWithChatter:model.username];
                            cellModel.nickName = showName?showName:cellModel.username;
                        }else {
                            cellModel.nickName = cellModel.username;
                        }
                        
                        if ([self->_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                            cellModel.headImageURL = [NSURL URLWithString:[self->_delelgate avatarWithChatter:cellModel.username]];
                        }
                        
                        //Demo集成Parse,获取用户个人信息
                        UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
                        
                        if (user && user.imageUrl.length > 0) {
                            model.headImageURL = [NSURL URLWithString:user.imageUrl];
                        }
                        
                        if (user && user.nickname.length > 0) {
                            model.nickName = user.nickname;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}

//SDK接收到消息时, 下载附件成功或失败的回调
- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}


//SDK接收到消息时, 下载附件的进度回调, 回调方法有不在主线程中调用, 需要App自己切换到主线程中执行UI的刷新等操作
- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}


// 收到消息时的回调
-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
}

//收到消息时的回调
-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:@"有透传消息"];
    }
}


// 收到发送消错误的回调
- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [_conversation.chatter isEqualToString:conversationChatter]) {
        
        __weak MMChatViewController *weakSelf = self;
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MMMessageModel class]]) {
                MMMessageModel *currentModel = [self.dataSource objectAtIndex:i];
                EMMessage *currMsg = [currentModel message];
                if ([messageId isEqualToString:currMsg.messageId]) {
                    currMsg.deliveryState = eMessageDeliveryState_Failure;
                    MMMessageModel *cellModel = [MessageModelManager modelWithMessage:currMsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                        
                    });
                    
                    if (error && error.errorCode == EMErrorMessageContainSensitiveWords)
                    {
                        CGRect frame = self.chatToolBar.frame;
                        [self showHint:@"你的消息包含不当言论" yOffset:-frame.size.height + KHintAdjustY];
                    }
                    break;
                }
            }
        }
    }
}


//接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (![offlineMessages count])
    {
        return;
    }
    if ([self shouldMarkMessageAsRead])
    {
        [_conversation markAllMessagesAsRead:YES];
    }
    _chatTagDate = nil;
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:[self.messages count] + [offlineMessages count] append:NO];
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (self.isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error && self.isChatGroup && [_chatter isEqualToString:group.groupId])
    {
        self.title = group.groupSubject;
        [self hideHud];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MMMessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        MMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MMMessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
        [self sendTextMessage:[userInfo objectForKey:@"text"]];
    }else if ([eventName isEqualToString:kRouterEventChatHeadImageTapEventName]) {
        [self chatHeadImagePressed:model];
    }
}


//聊天头像被点击
- (void)chatHeadImagePressed:(MMMessageModel *)model
{

}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MMMessageModel *)model
{

}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MMMessageModel *)model
{
    
    
    
}



#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{

}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}



#pragma mark - EMChatBarMoreViewDelegate
- (void)moreViewPhotoAction:(MMChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
   
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;

    
}

- (void)moreViewTakePicAction:(MMChatBarMoreView *)moreView{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:@"该设备不支持拍照"];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
#endif

}

- (void)moreViewFileAction:(MMChatBarMoreView *)moreView{
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    }];
    [self sendImageMessage:orgImage];
 
    self.isInvisible = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}



#pragma mark - MessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
   
    
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}


/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self canRecord]) {
        MMRecordView *tmpView = (MMRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"开始录音失败");
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            [weakSelf sendAudioMessage:voice];
        }else {
            [weakSelf showHudInView:self.view hint:@"录音时间太短了"];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
        }
    }];
}

#pragma mark - private

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
//    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
//    NSIndexPath *indexPath = nil;
//    if (playingModel) {
//        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
//    }
//    
//    if (indexPath) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView beginUpdates];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self.tableView endUpdates];
//        });
//    }
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            
            if (append)
            {
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (EMMessage *message in messages)
            {
                [weakSelf downloadMessageAttachments:message];
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        }
    });
}

- (void)downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:@"缩略图获取失败!"];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}


- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MMMessageModel *model = [MessageModelManager modelWithMessage:message];
            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                NSString *showName = [_delelgate nickNameWithChatter:model.username];
                model.nickName = showName?showName:model.username;
            }else {
                model.nickName = model.username;
            }
            
            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MMMessageModel *model = [MessageModelManager modelWithMessage:message];
    if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
        NSString *showName = [_delelgate nickNameWithChatter:model.username];
        model.nickName = showName?showName:model.username;
    }else {
        model.nickName = model.username;
    }
    
    if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
        model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
    }
    
    //Demo集成Parse,获取用户个人信息
    UserProfileEntity *user = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.username];
    
    if (user && user.imageUrl.length > 0) {
        model.headImageURL = [NSURL URLWithString:user.imageUrl];
    }
    
    if (user && user.nickname.length > 0) {
        model.nickName = user.nickname;
    }
    
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}



-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak MMChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessage:message];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}


- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}

- (EMMessageType)messageType
{
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)image
{
    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:ext];
    [self addMessage:tempMessage];
}


//发送一个"已读消息"(在UI上显示了或者阅后即焚的销毁的时候发送)的回执到服务器
- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

@end
