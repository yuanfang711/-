//
//  LogininViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "LogininViewController.h"
#import <BmobSDK/Bmob.h>


@interface LogininViewController ()
- (IBAction)addButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;


- (IBAction)modeifyButtonAction:(id)sender;

- (IBAction)selectButtonAction:(id)sender;

@end

@implementation LogininViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
}

- (void)showBackButton{
    [self .navigationController dismissViewControllerAnimated:YES completion:nil];
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
//添加
- (IBAction)addButtonAction:(id)sender {
    //往MenberUser表中添加一条数据
    BmobObject *user = [BmobObject objectWithClassName:@"MenberUser"];
    [user setObject:@"范芳芳" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_age"];
    [user setObject:@"女" forKey:@"user_Gander"];
    [user setObject:@"1854512455" forKey:@"user_Phone"];
   
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        FFFLog(@"恭喜注册成功");
    }];
}
//删除
- (IBAction)deleteButtonAction:(id)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
            NSLog(@"已经删除数据");
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
}

//修改
- (IBAction)modeifyButtonAction:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"云" forKey:@"user_Name"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
            NSLog(@"修改失败！");
        }
    }];
}
//查询
- (IBAction)selectButtonAction:(id)sender {
    //查找MenberUser表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MenberUser"];
    //查找MenberUser表里面id为的数据
    [bquery getObjectInBackgroundWithId:@"05fd54fc65" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
             NSLog(@"查询出错");
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *playerName = [object objectForKey:@"user_Name"];
                NSString *playerPhone = [object objectForKey:@"user_Phone"];
                NSLog(@"%@----%@",playerName,playerPhone);
            }
        }
    }];
}
@end
