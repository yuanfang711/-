//
//  MineViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "ShareView.h"
#import "LogininViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,WeiboSDKDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headViewButt;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UILabel *nicheng;

@property (nonatomic, strong ) WBMessageObject *messageToshare;


@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *shareView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArr = [[NSMutableArray alloc] initWithObjects:@"清除缓存",@"用户反馈",@"分享给好友",@"给我评分",@"当前版本 1.0", nil];
    self.imageArr = @[@"icon_order.png",@"icon_msg.png",@"icon_ele.png",@"icon_like.png",@"icon_ac.png"];
    
    self.tableView.separatorColor = [UIColor grayColor];
    
    //设置导航栏的颜色
    self.navigationController.navigationBar.barTintColor = kColor;
    [self.view addSubview:self.tableView];
    //调用设置区头的方法
    [self setUpHeadView];
    
}

//当xiew出现时调用此方法
-(void)viewWillAppear:(BOOL)animated{
    //大小
    SDImageCache *chche = [SDImageCache sharedImageCache];
    
    NSUInteger chachesize = [chche getSize];
    
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.2fM)",(float)chachesize/1024/1204];
    //使用替换，不能用插入，替换得出新写的数据。插入使原有的数组的个数多一个
    [self.titleArr replaceObjectAtIndex:0 withObject:cacheStr];
    //cell的位置；
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //刷新单行的cell
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

#pragma mark ------------- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellstring = @"cherry";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellstring];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellstring];
    }
    //点击cell时的颜色效果取消
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{//找到存储的位置NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
            //清除里面添加的图片
            SDImageCache *image = [SDImageCache sharedImageCache];
            //调用方法，清除所有一起拿存储的图片
            [image clearDisk];
            [self.titleArr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"清除缓存(%.0fM)",(float)[image getSize]]];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            //刷新单行的cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }break;
        case 1:{
            //发送邮件
            [self sendMail];
        }break;
        case 2:{
            //分享
            [self share];
//            [self shareView];
        } break;
        case 3:{
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }break;
        case 4:{
            //检测当前的版本
            [ProgressHUD show:@"正在为你检测…"];
            [self performSelector:@selector(chek) withObject:nil afterDelay:2.0];}   break;
        default:
            break;
    }
}
#pragma mark ******************** 分享小041界面
-(void)share{
    UIWindow *sharewindow = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc] initWithFrame:self.view.frame];
    self.blackView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.5];
    [sharewindow addSubview:self.blackView];
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [self.blackView addSubview:self.shareView];
    //微博
    UIButton *weibobutton = [UIButton buttonWithType:UIButtonTypeCustom];
    weibobutton.frame = CGRectMake(20, 20, 70, 70);
    [weibobutton setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_login_button_with_frame_logo_focused"] forState:UIControlStateNormal];
    [weibobutton addTarget:self action:@selector(getWeiBoShare) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weiboL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 70, 10)];
    weiboL.text = @"微博分享";
    weiboL.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weiboL];
    [self.shareView addSubview:weibobutton];
    
    //微信朋友
    UIButton *friendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    friendbutton.frame = CGRectMake(130, 20, 70, 70);
    [friendbutton setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
    [friendbutton addTarget:self action:@selector(getFriendShare) forControlEvents:UIControlEventTouchUpInside];
    UILabel *weixinL = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 70, 10)];
    weixinL.text = @"微信好友";
    weixinL.textAlignment = NSTextAlignmentCenter;
    [self.shareView addSubview:weixinL];
    [self.shareView addSubview:friendbutton];
    //朋友圈
    UIButton *circlebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    circlebutton.frame = CGRectMake(250, 20, 70, 70);
    [circlebutton setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
    [circlebutton addTarget:self action:@selector(getCircleShare) forControlEvents:UIControlEventTouchUpInside];
    UILabel *circleL = [[UILabel alloc] initWithFrame:CGRectMake(240, 90, 90, 10)];
    circleL.text = @"朋友圈分享";
    [self.shareView addSubview:circleL];
    [self.shareView addSubview:circlebutton];
    
    //清除
    UIButton *removebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    removebutton.frame = CGRectMake(30, 120, ScreenWidth - 60, 30);
    removebutton.backgroundColor = [UIColor brownColor];
    [removebutton setTitle:@"取消" forState:UIControlStateNormal];
    [removebutton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removebutton];

    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.6;
        self.shareView.frame =CGRectMake(0, ScreenHeight - 240, ScreenWidth, 240);
        self.tabBarController.tabBar.hidden = YES;
    }];
    
}

- (WBMessageObject *)messageToshare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"此内容由嗨皮周末测试使用分享";
    return message;
}

//微博分享
- (void)getWeiBoShare{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = KRedirectURI;
    authRequest.scope = @"all";
//    authRequest.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController"};
    
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToshare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    [self getBack];
}
//回调信息
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSLog(@"%@",response);
}

- (void)getFriendShare{
    
}
- (void)getCircleShare{
    
}
- (void)getBack{
    [UIView animateWithDuration:1.0 animations:^{
        [self.shareView removeFromSuperview];
        [self.blackView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
    }];
}

#pragma mark *************** 版本信息的点击方法
- (void)chek{
    [ProgressHUD showSuccess:@"当前已经是最新版本"];
}

#pragma mark **************  tableview的懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 210, ScreenWidth, ScreenHeight/2 - 110) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
#pragma mark -***-*-*-*-*-*-*- 用户反馈的点击方法
- (void)sendMail{
    Class mailclass = NSClassFromString(@"MFMailComposeViewController");
    if (!mailclass) {
        if ([MFMailComposeViewController canSendMail]) {
            //初始化
            MFMailComposeViewController *pickerVC = [[MFMailComposeViewController alloc] init];
            //设置代理
            pickerVC.mailComposeDelegate = self;
            //设置主题
            [pickerVC setSubject:@"用户反馈"];
            //设置接受者
            NSArray *receive = [NSArray arrayWithObjects:@"1498012357@qq.com", nil];
            [pickerVC setToRecipients:receive];
            //设置发送内容
            NSString *text = @"请留下你宝贵的意见";
            [pickerVC setMessageBody:text isHTML:NO];
            //推出视图
            [self presentViewController:pickerVC animated:YES completion:nil];
        }else{
            FFFLog(@"未配置邮箱账号");
        }
    }else{
        FFFLog(@"设备不支持发送邮件");
    }
}

//邮件发送完成，调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled://取消
            NSLog(@"取消");
            break;
        case MFMailComposeResultSaved:  //保存
            NSLog(@"保存邮件");
            break;
        case MFMailComposeResultSent:   //发送
            NSLog(@"发送邮件");
            break;
        case MFMailComposeResultFailed:  //失败
            NSLog(@"发送失败，尝试保存");
            [error localizedDescription];
            break;
        default:
            break;
    }
}

#pragma mark *---------------  区头
- (void)setUpHeadView{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
    headview.
    backgroundColor = kColor;
    self.headViewButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headViewButt.frame = CGRectMake(30, 30, 130, 130);
    [self.headViewButt setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.headViewButt addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.headViewButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.headViewButt setBackgroundColor:[UIColor whiteColor]];
    self.headViewButt.layer.cornerRadius = 65;
    self.headViewButt.clipsToBounds = YES;
    self.nicheng = [[UILabel alloc] initWithFrame:CGRectMake(168, 80, ScreenWidth - 180, 40)];
    self.nicheng.text = @"欢迎进入嗨皮周末！！！";
    self.nicheng.textColor = [UIColor whiteColor];
    [headview addSubview:self.nicheng];
    [headview addSubview:self.headViewButt];
    [self.view addSubview:headview];
}
- (void)login{
    UIStoryboard *striu = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    LogininViewController *loginVC = [striu instantiateViewControllerWithIdentifier:@"loginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];

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
