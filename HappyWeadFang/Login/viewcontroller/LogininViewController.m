//
//  LogininViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "LogininViewController.h"
#import <BmobSDK/Bmob.h>
#import "RegisterViewController.h"
#import "ProgressHUD.h"

@interface LogininViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userLable;

@property (weak, nonatomic) IBOutlet UITextField *passLable;

@end

@implementation LogininViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButtonWithImage:@"back"];
    
    self.passLable.secureTextEntry = YES;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 64, 44);
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selectWord) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnu = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnu;
}

- (IBAction)loginButtonAction:(id)sender {
    [ProgressHUD show:@"正在登陆..."];
    [BmobUser loginWithUsernameInBackground:self.userLable.text password:self.passLable.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            FFFLog(@"登录成功！！！");
            [ProgressHUD showSuccess:@"登录成功！"];
        }else{
            [ProgressHUD showError:@"登录失败"];
        }
    }];
    
    
}


- (void)showBackButtonWithImage:(NSString *)imageName{
    [self .navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectWord{
    UIStoryboard *registers = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    RegisterViewController *regisVC = [registers instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:regisVC animated:YES];
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
////添加
//- (IBAction)addButtonAction:(id)sender {
//    //往MenberUser表中添加一条数据
//    BmobObject *user = [BmobObject objectWithClassName:@"MenberUser"];
//    [user setObject:@"范芳芳" forKey:@"user_Name"];
//    [user setObject:@18 forKey:@"user_age"];
//    [user setObject:@"女" forKey:@"user_Gander"];
//    [user setObject:@"1854512455" forKey:@"user_Phone"];
//   
//    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        //进行操作
//        FFFLog(@"恭喜注册成功");
//    }];
//}
////删除
//- (IBAction)deleteButtonAction:(id)sender {
//    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
//    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object, NSError *error){
//        if (error) {
//            //进行错误处理
//            NSLog(@"已经删除数据");
//        }
//        else{
//            if (object) {
//                //异步删除object
//                [object deleteInBackground];
//            }
//        }
//    }];
//}
//
////修改
//- (IBAction)modeifyButtonAction:(id)sender {
//    //查找GameScore表
//    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
//    //查找GameScore表里面id为0c6db13c的数据
//    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object,NSError *error){
//        //没有返回错误
//        if (!error) {
//            //对象存在
//            if (object) {
//                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
//                //设置cheatMode为YES
//                [obj1 setObject:@"云" forKey:@"user_Name"];
//                //异步更新数据
//                [obj1 updateInBackground];
//            }
//        }else{
//            //进行错误处理
//            NSLog(@"修改失败！");
//        }
//    }];
//}
////查询
//- (IBAction)selectButtonAction:(id)sender {
//    //查找MenberUser表
//    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
//    //查找MenberUser表里面id为的数据
//    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object,NSError *error){
//        if (error){
//            //进行错误处理
//             NSLog(@"查询出错");
//        }else{
//            //表里有id为0c6db13c的数据
//            if (object) {
//                //得到playerName和cheatMode
//                NSString *playerName = [object objectForKey:@"user_Name"];
//                NSString *playerPhone = [object objectForKey:@"user_Phone"];
//                NSLog(@"%@----%@",playerName,playerPhone);
//            }
//        }
//    }];
//}
@end
