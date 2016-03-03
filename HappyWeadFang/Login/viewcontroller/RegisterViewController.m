//
//  RegisterViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/3/2.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"


@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UISwitch *passShowSwitch;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *assginPassText;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机号注册";
    [self showBackButtonWithImage:@"back"];
    
    //密码密文显示
    self.passText.secureTextEntry = YES;
    self.assginPassText.secureTextEntry = YES;
    
    //默认swtich关闭
    self.passShowSwitch.on = NO;
}
//显示密码
- (IBAction)passShowAction:(id)sender {
    UISwitch *swith = sender;
    if (swith.on) {
        self.passText.secureTextEntry = NO;
        self.assginPassText.secureTextEntry = NO;
    }else
    {
        self.passText.secureTextEntry = YES;
        self.assginPassText.secureTextEntry = YES;
    }
}
//注册
- (IBAction)registerAction:(id)sender {
    if (![self cieck]) {
        return;
    };
    [ProgressHUD show:@"正在注册中…"];
    BmobUser *user = [[BmobUser alloc] init];
    [user setUsername:self.userName.text];
    [user setPassword:self.passText.text];
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友好提示" message:@"你已注册成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                FFFLog(@"成功！！！");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                FFFLog(@"失败！！！");
            }];
            [alertC addAction:okAction];
            [alertC addAction:cancelAction];
            [self presentModalViewController:alertC animated:YES];
//            FFFLog(@"注册成功");
        }else{
            [ProgressHUD showError:@"注册失败"];
            FFFLog(@"注册失败");

        }
    }];
}
//注册前的判断
- (BOOL)cieck{
    //用户名不能为空且不可为空格
    if (self.userName.text.length <= 0 && [self.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertView *userView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空且不能出现空格" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [userView show];
        return NO;
    }//
    if (![self.passText.text isEqualToString:self.assginPassText.text]){
        //提示框
        UIAlertView *passView = [[UIAlertView alloc] initWithTitle:nil message:@"密码两次输入不同，请再次输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        [passView show];
        return NO;
    }//用正则表达式来判断是手机挂号
    if (self.passText.text.length <= 0 && [self.passText.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0){
        //提示密码不为空
        return NO;
    }
    return YES;
}

#pragma mark ----------  回收键盘
//点击换行见回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
//    [self.userName resignFirstResponder];
//    [self.passText resignFirstResponder];
//    [self.assginPassText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
