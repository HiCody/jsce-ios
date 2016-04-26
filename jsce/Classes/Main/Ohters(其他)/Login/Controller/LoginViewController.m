//
//  LoginViewController.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+RenderedImage.h"
#import "AppDelegate.h"
#import "JsceTarBarController.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *paneView;
@property (weak, nonatomic) IBOutlet UIView *paneView2;
@property (strong, nonatomic)NSMutableArray *orgArr;

@end

@implementation LoginViewController
- (NSMutableArray *)orgArr{
    if (!_orgArr) {
        _orgArr = [[NSMutableArray alloc] init];
    }
    return _orgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate=self;
    self.passWordTextField.delegate=self;
    
    
    //从沙盒中加载保存的账户
    Account *account=[Account shareAccount];
    [account loadAccountFromSanbox];
    NSString *user=account.userName;
    NSString *passWord=account.passWord;
    self.nameTextField.text=user;
    self.passWordTextField.text=passWord;
        
    //设置paneView的显示样式
    self.paneView.layer.borderWidth=1.0;
    self.paneView.layer.borderColor=[UIColor clearColor].CGColor;
    self.paneView.layer.cornerRadius=4.0;
    
    self.paneView2.layer.borderWidth=1.0;
    self.paneView2.layer.borderColor=[UIColor clearColor].CGColor;
    self.paneView2.layer.cornerRadius=4.0;
    
    //登陆按钮图片拉升
    UIImage *btnImg=[UIImage imageWithRenderColor:[UIColor hexFloatColor:@"2981f6"] renderSize:CGSizeMake(WinWidth, WinHeight)];
    [self.loginBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexFloatColor:@"68beff"] renderSize:CGSizeMake(WinWidth, WinHeight)] forState:UIControlStateHighlighted];
    self.loginBtn.layer.borderWidth=1.0;
    self.loginBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    self.loginBtn.layer.cornerRadius=4.0;
    // self.loginBtn.enabled=NO;
    
    //键盘弹出视图上移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.nameTextField addTarget:self  action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration =[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame =[notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transfomY=(keyBoardFrame.origin.y-self.view.frame.size.height)/3;
    // NSLog(@"%f",transfomY);
    [UIView animateWithDuration:duration animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, transfomY);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shakeActionWithTextField:(UITextField *)textField
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.01f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 方法一：绘制路径
    CGRect frame = textField.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径 幅度由大变小
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
    // 闭合
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    // 释放
    CFRelease(shakePath);
    
    [textField.layer addAnimation:shakeAnimation forKey:kCATransition];
}

- (void)textChange:(UITextField *)textField{
    
    
    //限制输入的字数长度
    if (textField == self.nameTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
    
    if (textField == self.passWordTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}

- (IBAction)signIn:(id)sender {
    //账号或密码为空是抖动
    if (!self.nameTextField.text.length||!self.passWordTextField.text.length) {
        if (!self.nameTextField.text.length) {
            [self shakeActionWithTextField:self.nameTextField];
        }else{
            [self shakeActionWithTextField:self.passWordTextField];
        }
    }else{
        
        [self requestLoginWithName:self.nameTextField.text pwd:self.passWordTextField.text];
        
    }
    
    [self.nameTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (void)requestLoginWithName:(NSString*)name pwd:(NSString*)pwd{
    [MBProgressHUD showMessage:@"登陆中..." toView:self.view];
    [LoginModel doLogin:name pwd:pwd success:^(AFHTTPRequestOperation *operation, id result) {
     
        NSDictionary *dict=result;
        if ([dict[@"status"] intValue] == 200) {
           
            UserInfo *tempUserInfo = [UserInfo objectWithKeyValues:dict[@"items"]];
            
            UserInfo *userInfo =[UserInfo shareUserInfo];
            
            userInfo.userId  = tempUserInfo.userId;
            userInfo.topOrgName=tempUserInfo.topOrgName;
            userInfo.topOrgId=tempUserInfo.topOrgId;
            userInfo.rights=tempUserInfo.rights;
            userInfo.realName = tempUserInfo.realName;
            userInfo.email = tempUserInfo.email;
            userInfo.phone = tempUserInfo.phone;
            
            Account *account=[Account shareAccount];
            if (self.nameTextField.text.length&&self.nameTextField.text.length) {
                account.userName=self.nameTextField.text;
                account.passWord=self.passWordTextField.text;
                [account saveAccountToSanbox];
            }

            
            //组织切换
            [LoginModel organizationChange:^(AFHTTPRequestOperation *operation, id result) {
               
                NSDictionary *dict=result;
                NSArray *tempArr= dict[@"items"];
                
                NSArray *organizationArr=[OrganizationContent objectArrayWithKeyValuesArray:tempArr];

                NSMutableArray *topOrgIdArr=[[NSMutableArray alloc] init];
                NSMutableArray *rightsArr = [[NSMutableArray alloc] init];
                for (OrganizationContent *org in organizationArr) {
                    [self.orgArr addObject:org.topOrgName];
                    [topOrgIdArr addObject:org.topOrgId];
                    [rightsArr addObject:org.rights];
                }
                
                Organization *organization = [Organization shareOrganization];
                organization.organizationArr  = [self.orgArr copy];
                organization.topOrgIdArr = [topOrgIdArr copy];
                organization.rightsArr  = [rightsArr copy];
                
                /**
                 *  环信登陆
                 *
                 *  @param
                 *
                 *  @return
                 */
                BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
                if (!isAutoLogin) {
                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:name password:pwd completion:^(NSDictionary *loginInfo, EMError *error) {
                        if (loginInfo && !error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            //设置推送设置
                            [[EaseMob sharedInstance].chatManager setApnsNickname:userInfo.realName];
                            
                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            //获取数据库中数据
                            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                            
                            //获取群组列表
                            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                            
                            //发送自动登陆状态通知
                            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                        }else{
                            
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:dict[@"msg"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            
                        }
                    } onQueue:nil];
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                    
                }
     
                
                
            } failure:^(NSError *error) {
                                
            }];

        }else{
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:dict[@"msg"]delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"请检查网络设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
