//
//  ThemeViewViewController.m
//  活动专题
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ThemeViewViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityThemeView.h"

@interface ThemeViewViewController ()
@property(nonatomic, strong) ActivityThemeView *themeView;
@end

@implementation ThemeViewViewController
- (void)loadView{
    [super loadView];
    self.themeView = [[ActivityThemeView alloc] initWithFrame:self.view.frame];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.themeView];
    [self getModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //返回图标
    [self showBackButtonWithImage:@"back"];
}

- (void)getModel{
    AFHTTPSessionManager *sessionM = [[AFHTTPSessionManager alloc] init];
    sessionM.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    [sessionM GET:[NSString stringWithFormat:@"%@&id=%@",kActivityTheme,self.themeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            self.themeView.dataDic = dic[@"success"];
            self.navigationItem.title = dic[@"success"][@"title"];
        }
        //        FFFLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
}

-(ActivityThemeView *)themeView{
    if (_themeView == nil) {
        self.themeView = [[ActivityThemeView alloc] init];
    }
    return _themeView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
+
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
