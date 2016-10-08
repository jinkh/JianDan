//
//  CenterController.m
//  FunnyProject
//
//  Created by Zinkham on 16/7/13.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "CenterController.h"

@interface CenterController ()<UITextFieldDelegate>

{
    UITextField *_passText;
    UITextField *_userNameText;
    
    UIButton *registerBtn;
}
@end
@implementation CenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = Controller_Bg;
    self.zh_showCustomNav = YES;
    self.zh_title = @"个人中心";
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitle:@"\U0000e6b4" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = IconFont(20);
    [leftBtn addTarget:self action:@selector(showLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.zh_customNav addSubview:leftBtn];
    
    if (self.navigationController.viewControllers.count > 1) {
        leftBtn.hidden = YES;
    }
    
    
    UILabel *nameLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    nameLeftView.text = @"\U0000e6b8";
    nameLeftView.font = IconFont(20);
    nameLeftView.textColor = [UIColor grayColor];
    nameLeftView.textAlignment = NSTextAlignmentCenter;
    
    _userNameText=[[UITextField alloc] initWithFrame:CGRectMake(10, 10+64, ScreenSize.width-20, 50.0)];
    _userNameText.placeholder=@"请输入昵称";
    _userNameText.dk_backgroundColorPicker = Cell_Bg;
    _userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameText.delegate=self;
    _userNameText.font = DefaultFont(17);
    _userNameText.leftView =nameLeftView;
    _userNameText.leftViewMode = UITextFieldViewModeAlways;
    _userNameText.tag=1;
    _userNameText.textColor = [UIColor grayColor];
    [_userNameText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _userNameText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_userNameText];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(10, 50+10+64, ScreenSize.width-20, .5)];
    lineOne.dk_backgroundColorPicker = Sep_Bg;
    lineOne.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:lineOne];
    
    
    UILabel *passLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    passLeftView.text = @"\U0000e69f";
    passLeftView.font = IconFont(20);
    passLeftView.textColor = [UIColor grayColor];
    passLeftView.textAlignment = NSTextAlignmentCenter;
    
    _passText=[[UITextField alloc] initWithFrame:CGRectMake(10, 51+10+64, ScreenSize.width-20, 50)];
    _passText.placeholder=@"请输入邮箱";
    _passText.dk_backgroundColorPicker = Cell_Bg;
    _passText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passText.delegate=self;
    _passText.textColor = [UIColor grayColor];
    [_passText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passText.font = DefaultFont(17);
    _passText.leftView =passLeftView;
    _passText.leftViewMode = UITextFieldViewModeAlways;
    _passText.tag=2;
    _passText.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_passText];
    
    
    registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, _passText.frame.origin.y+_passText.frame.size.height+30, ScreenSize.width-20, 40)];
    registerBtn.dk_backgroundColorPicker = Cell_Bg;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn dk_setTitleColorPicker:Text_Title forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = DefaultFont(17);
    registerBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [registerBtn addTarget:self action:@selector(sendRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *name =  [UserManager getUSerName];
    if (name != nil) {
        _userNameText.text = name;
    }
    
    NSString *email =  [UserManager getUSerEmail];
    if (email != nil) {
        _passText.text = email;
    }
    
    if (name != nil && email != nil) {
        registerBtn.hidden = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
      registerBtn.hidden = NO;
}

- (void)sendRegister:(id)sender
{
    if (_userNameText.text && _userNameText.text.length <= 0) {
        [[ToastHelper sharedToastHelper] toast:@"请输入昵称"];
         return;
    }
    if (_passText.text && _passText.text.length <= 0) {
        [[ToastHelper sharedToastHelper] toast:@"请输入邮箱"];
         return;
    }
    if ([CATCommon isEmailAddress:_passText.text] == NO) {
        [[ToastHelper sharedToastHelper] toast:@"邮箱不正确"];
        return;
    }
     [[ToastHelper sharedToastHelper] toast:@"保存成功"];

    [UserManager saveUSerEmail:_passText.text];
    [UserManager saveUSerName:_userNameText.text];
    
    registerBtn.hidden = YES;
    [self.view endEditing:YES];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showLeftMenu
{
    [self.view endEditing:YES];
    [TheAppDelegate.deckController openLeftView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
