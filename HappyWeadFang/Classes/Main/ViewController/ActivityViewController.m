//
//  ActivityViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MBProgressHUD.h"


@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor magentaColor];
    self.title = @"活动详情";
    
        
    //网络请求
//    [self getModel];
}
#pragma mark ----------- 网络请求
- (void)getModel{
   //初始化
    AFHTTPSessionManager *sessionM = [[AFHTTPSessionManager alloc] init];
    ;
    NSLog(@"%@&%@",kActivityDetail,self.activityID);
    sessionM.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //请求开始之前，加
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [sessionM GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
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
