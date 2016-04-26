//
//  OptionsViewController.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "OptionsViewController.h"
#import "UIImage+Circle.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "PersonalInfoViewController.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface OptionsViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIWebView  *phoneCallWebView;
    NSArray *sectionTwoArr;
    NSArray *sectionThreeArr;
    Account *account;
}
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UISwitch *shockSw;
@property(nonatomic,strong)UISwitch *soundSw;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.showBackBtn=YES;
    [self configSoundAndShockSwich];
    
    self.tableView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight=0;
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    sectionTwoArr = @[@"震动",@"声音"];
    sectionThreeArr = @[@"清空缓存",@"联系我们"];
}

- (void)configSoundAndShockSwich{
    //配置震动和声音的开启与关闭
    self.shockSw=[[UISwitch alloc] init];
    [self.shockSw addTarget:self action:@selector(shockSwitchAction:) forControlEvents:UIControlEventValueChanged];
    self.soundSw=[[UISwitch alloc] init];
    [self.soundSw addTarget:self action:@selector(soundSwitchAction:) forControlEvents:UIControlEventValueChanged];
    account=[Account shareAccount];
    if(account.sound==nil) {
        account.sound=@"YES";
        self.shockSw.on=YES;
        [account saveAccountToSanbox];
    }
    if(account.shock==nil) {
        self.shockSw.on=YES;
        account.shock=@"YES";
        [account saveAccountToSanbox];
    }

}

- (void)soundSwitchAction:(UISwitch *)sw{
    //  sw.on=!sw.on;
    
    if (sw.on==YES) {
        account.sound=@"YES";
    }else{
        account.sound=@"NO";
    }
    [account saveAccountToSanbox];
}

- (void)shockSwitchAction:(UISwitch *)sw{
    //  sw.on=!sw.on;
    
    if (sw.on==YES) {
        account.shock=@"YES";
    }else{
        account.shock=@"NO";
    }
    [account saveAccountToSanbox];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1|| section==2) {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section ==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIImage *img = [UIImage circleImageWithName:@"initial_head_portrait" borderWidth:0 borderColor:nil];
        UIImageView *imgView=[[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(15, 10,60 , 60);
        [cell.contentView addSubview:imgView];
        
        UILabel *nameLable=[[UILabel alloc] initWithFrame:CGRectMake(85, 35, 100, 10)];
        
       nameLable.text = [UserInfo shareUserInfo].realName;
        [cell.contentView addSubview:nameLable];
        
    }else if(indexPath.section==1){
        
        cell.textLabel.font =[UIFont systemFontOfSize:15.0];
        cell.textLabel.text = sectionTwoArr[indexPath.row];
        
         [account loadAccountFromSanbox];
        if (indexPath.row==0) {
            self.shockSw.on= [account.shock boolValue];
            cell.accessoryView=self.shockSw;
        }else{
            self.soundSw.on=  [account.sound boolValue];
            cell.accessoryView=self.soundSw;
        }
        
        
    }else if(indexPath.section ==2){
        cell.textLabel.font =[UIFont systemFontOfSize:15.0];
        cell.textLabel.text = sectionThreeArr[indexPath.row];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;;
    }else{
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WinWidth, cell.frame.size.height)];
        lable.textColor=[UIColor redColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:15.0];
        lable.text=@"退出登录";
        [cell.contentView addSubview:lable];
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        //跳转到个人信息页面
        
        PersonalInfoViewController *personalInfoVC=[[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:personalInfoVC animated:YES];
        
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            //清空缓存
            
            
        }else{
            //联系我们
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系我们" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"联系电话:025-58951000",@"电子邮件:bangongshi@jsce.com.cn",nil];
            [alertView show];
        }
        
    }else if(indexPath.section==3){
        //退出当前账号
        
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"是否退出" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
        
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [self dialPhoneNumber:@"025-58951000"];
        
    }else if(buttonIndex == 2){
        [self showMailPicker];
    }
}

//调出电话功能
- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

//调出邮箱功能
- (void)showMailPicker{
    Class mailClass =(NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        if (![mailClass canSendMail]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"用户没有设置邮件账户" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            [self displayMailPicker];
        }
    }
    
}

-(void)displayMailPicker{
    MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
    mailController.view.frame=self.view.frame;
    mailController.mailComposeDelegate=self;
    
    //设置邮件发送的主题
    
    //添加收件人
    NSArray *emailAddress;
    emailAddress=@[@"bangongshi@jsce.com.cn"];
    [mailController setToRecipients:emailAddress];
    
    //设置正文
    NSString *emailBody=@"</font> 正文";
    [mailController setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailController animated:YES completion:nil];
}


#pragma mark -MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //关闭发送邮件窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    /*
     MFMailComposeResultCancelled,
     MFMailComposeResultSaved,
     MFMailComposeResultSent,
     MFMailComposeResultFailed
     */
    switch (result) {
        case MFMailComposeResultCancelled:
            msg=@"用户取消发送邮件";
            break;
        case MFMailComposeResultSaved:
            msg=@"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg=@"用户成功发送邮件";
            break;
        case MFMailComposeResultFailed:
            msg=@"用户发送邮件失败";
            break;
            
        default:
            break;
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {

        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {

            if (error && error.errorCode != EMErrorServerNotLogin) {
//                [weakSelf showHint:error.description];
            }
            else{
              //  [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
        } onQueue:nil];

        
        
        
    }
}


@end
