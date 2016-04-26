//
//  AppDelegate.m
//  jsce
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "AppDelegate.h"
#import "JsceTarBarController.h"
#import "LoginViewController.h"

#import "AppDelegate+EaseMob.h"
#import "MMApplyFriendViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    _connectionState = eEMConnectionConnected;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
//    Account *account=[Account shareAccount];
//    [account loadAccountFromSanbox];
//    BOOL isAutoLogin1=account.userName&&account.passWord;
//    if (isAutoLogin1){
//        LoginViewController *loginVC=[[LoginViewController alloc] init];
//        [loginVC requestLoginWithName:account.userName pwd:account.passWord];
//        self.window.rootViewController  = loginVC;
//        
//    }else {
//        [self signOut];
//    }
//    
    
    
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    
    [self loginStateChange:nil];
    
    [self.window makeKeyAndVisible];
    


    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        //加载申请通知的数据
       [[MMApplyFriendViewController shareController] loadDataSourceFromLocalDB];
        
    if (_jsceTBC == nil) {
        
        _jsceTBC = [[JsceTarBarController alloc] init];
        [_jsceTBC networkChanged:_connectionState];
        
        Account *account=[Account shareAccount];
        [account loadAccountFromSanbox];
    
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        [loginVC requestLoginWithName:account.userName pwd:account.passWord];
        self.window.rootViewController  = loginVC;
        
            
         self.window.rootViewController= _jsceTBC;
            
        }else{
        
            self.window.rootViewController= _jsceTBC;
        }
        
        
    }else{//登陆失败加载登陆页面控制器
        _jsceTBC = nil;
        
        [self signOut];
    }
    


}



- (void)LoginIn{
   
    JsceTarBarController *tabBar=[[JsceTarBarController alloc] init];;
    
    self.window.rootViewController=tabBar;
}

- (void)signOut{
    LoginViewController *loginVC=[[LoginViewController alloc] init];
    self.window.rootViewController  = loginVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
