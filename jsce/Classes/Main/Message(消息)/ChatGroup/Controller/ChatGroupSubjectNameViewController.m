//
//  ChatGroupSubjectNameViewController.m
//  jsce
//
//  Created by 顾佳洪 on 15/10/21.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "ChatGroupSubjectNameViewController.h"

@interface ChatGroupSubjectNameViewController ()<UITextFieldDelegate>{
    EMGroup         *_group;
    BOOL            _isOwner;
    UIBarButtonItem *rightBarButtonItem;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong)UIButton *sureButton;

@end

@implementation ChatGroupSubjectNameViewController
- (instancetype)initWithGroup:(EMGroup *)group
{
    self = [self init];
    if (self) {
        _group = group;
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        _isOwner = [_group.owner isEqualToString:loginUsername];
       
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"群聊名称";
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239/255.0f blue:244/255.f alpha:1.0f];
    self.showBackBtn = YES;
    _textField.delegate =self;
    _textField.text  = _group.groupSubject;
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self setUpRightBtn];
    
    if (!_isOwner)
    {
        _textField.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpRightBtn{
    if (_isOwner)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -18;
        
        self.sureButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
        [self.sureButton setTitle:@"完成" forState:UIControlStateNormal];
        self.sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.sureButton.titleLabel.textAlignment= NSTextAlignmentRight;
        [self.sureButton setEnabled:NO];
        [self.sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(changeGroupSubject:) forControlEvents:UIControlEventTouchUpInside];
        
        rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sureButton];
        rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItems = @[negativeSeperator,rightBarButtonItem ];

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];// 1
    if (_isOwner) {
        
        [self.textField becomeFirstResponder];
    }
    // 2
}

- (void)changeGroupSubject:(UIButton *)btn{
    [self.textField resignFirstResponder];
  //  if (![_textField.text isEqual:_group.groupSubject]) {
    
    [self showHudInView:self.view hint:@"正在保存..."];
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_textField.text forGroup:_group.groupId];
//        [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_textField.text forGroup:_group.groupId completion:^(EMGroup *group, EMError *error) {
//            [self hideHud];
//            if (!error) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        } onQueue:nil];
  //  }
    
    
   
}



- (void)textFieldChanged:(UITextField *)textField{
        [self.sureButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        rightBarButtonItem.enabled=YES;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

@end
