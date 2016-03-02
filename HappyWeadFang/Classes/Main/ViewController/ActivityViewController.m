//
//  ActivityViewController.m
//  活动详情
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AcyivityDetailView.h"
#import "MainViewController.h"

@interface ActivityViewController ()
{
    NSString *_phoneNum;
}

@property (strong, nonatomic) IBOutlet AcyivityDetailView *activityDetailView;


@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.scrollV.backgroundColor = [UIColor cyanColor];
    self.title = @"活动详情";

    [self showBackButtonWithImage:@"back"];
    
    
    //隐藏TabBar
    self.tabBarController.tabBar.hidden = YES;
    //去地图界面
    [self.activityDetailView.mapButton addTarget:self action:@selector(goToMap:) forControlEvents:UIControlEventTouchUpInside];
    //打电话
    [self.activityDetailView.makeCallButt addTarget:self action:@selector(goCellPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //网络请求
    [self getModel];
}
#pragma mark ----------- 网络请求
- (void)getModel{
   //初始化
    AFHTTPSessionManager *sessionM = [[AFHTTPSessionManager alloc] init];
    ;
    sessionM.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionM GET:[NSString stringWithFormat:@"%@&id=%@",kActivityDetail,self.activityID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code" ] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
           // NSLog(@"%@",successDic);
            self.activityDetailView.dataDic = successDic;
            _phoneNum = dic[@"tel"];
        }else{
            
        }
//        FFFLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
    }];
    
}

- (void)goToMap:(UIButton *)button{
    
}
//打电话
- (void)goCellPhone:(UIButton *)button{
  
     //程序外打电话，之后不再返回当前的应用程序
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_phoneNum]]];
    
    //程序内：打完电话后还返回当前的应用程序
    UIWebView *cellPhoneNum = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel :%@",_phoneNum]]];
    [cellPhoneNum loadRequest:request];
    [self.view addSubview:cellPhoneNum];
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
