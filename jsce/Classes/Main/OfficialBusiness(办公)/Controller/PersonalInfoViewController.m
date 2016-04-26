//
//  PersonalInfoViewController.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "OfficialBusiness.h"
#import "UIImage+Circle.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *sectionOneArr;
@property(nonatomic,strong)NSArray *sectionTwoArr;
@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"个人信息";
    self.showBackBtn=YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight=0;
    [self.view addSubview:self.tableView];
    
    self.sectionOneArr=@[@"头像",@"姓名",@"当前所属公司"];
    self.sectionTwoArr=@[@"Email",@"手机"];
    
    [self setupRightBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration =[notification.userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardFrame =[notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transfomY=(keyBoardFrame.origin.y-self.tableView.frame.size.height)/3;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, transfomY);
    }];
}

- (void)setupRightBtn{

    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"保存" action:^{
        [self saveData];
    }];
}

//保存用户信息并上传更新
- (void)saveData{
    UITextField *nameTextField=(UITextField *)[self.view viewWithTag:100];
    UITextField *emailTextField=(UITextField *)[self.view viewWithTag:101];
    UITextField *phoneTextField=(UITextField *)[self.view viewWithTag:102];
 
    [MBProgressHUD showMessage:@"上传中..." toView:self.view];
    [OfficialBusiness commitUserInfoAfterChangedWithRealName:nameTextField.text Email:emailTextField.text Phone:phoneTextField.text success:^(AFHTTPRequestOperation *operation, id result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dict =  result;
        if ([dict[@"status"] intValue]==200) {
            
            UserInfo *userInfo=[UserInfo shareUserInfo];
            userInfo.realName =nameTextField.text;
            userInfo.email = emailTextField.text;
            userInfo.phone  = phoneTextField.text;
            
            [TSMessage showNotificationWithTitle:dict[@"msg"] subtitle:nil type:TSMessageNotificationTypeSuccess];
        }else{
            [TSMessage showNotificationWithTitle:dict[@"msg"] subtitle:nil type:TSMessageNotificationTypeError];
        }

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.sectionOneArr.count;
    }
    return self.sectionTwoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:15.0];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text =self.sectionOneArr[indexPath.row];
           
//后期用来加载头像图片
            UIImage *img=[UIImage circleImageWithName:@"initial_head_portrait" borderWidth:0 borderColor:nil];
            UIImageView *imgView=[[UIImageView alloc] initWithImage:img];
            
            imgView.frame = CGRectMake(W(220), 10, 60, 60);
            [cell.contentView addSubview:imgView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row==1){
            cell.textLabel.text =self.sectionOneArr[indexPath.row];
            UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(W(320)-115, 2, 100, cell.frame.size.height-4)];
            textField.tag=100;
            textField.textAlignment=NSTextAlignmentRight;
            textField.font=[UIFont systemFontOfSize:15.0];
            textField.text=[UserInfo shareUserInfo].realName;
            textField.delegate = self;
            [cell.contentView addSubview:textField];
        }else{
            
            cell.textLabel.text =self.sectionOneArr[indexPath.row];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0];
            
            cell.detailTextLabel.text =[UserInfo shareUserInfo].topOrgName;
            
        }
        
    }
    
    if (indexPath.section ==1) {
        if(indexPath.row==0){
            cell.textLabel.text =self.sectionTwoArr[indexPath.row];
            UITextField *emailTextField=[[UITextField alloc] initWithFrame:CGRectMake(W(320)-215, 2, 200, cell.frame.size.height-4)];
            
            emailTextField.tag= 101;
            emailTextField.textAlignment=NSTextAlignmentRight;
            emailTextField.font=[UIFont systemFontOfSize:15.0];
            emailTextField.text=[UserInfo shareUserInfo].email;
            emailTextField.delegate = self;
            [cell.contentView addSubview:emailTextField];
            
        }else if (indexPath.row==1){
            
            cell.textLabel.text =self.sectionTwoArr[indexPath.row];
            UITextField *phoneTextField=[[UITextField alloc] initWithFrame:CGRectMake(W(320)-215, 2, 200, cell.frame.size.height-4)];
            phoneTextField.tag= 102;
            phoneTextField.textAlignment=NSTextAlignmentRight;
            phoneTextField.font=[UIFont systemFontOfSize:15.0];
            phoneTextField.text=[UserInfo shareUserInfo].phone;
            phoneTextField.delegate = self;
            [cell.contentView addSubview:phoneTextField];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80;
        }
        
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

