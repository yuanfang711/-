//
//  ShareView.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UIView *shareView;
@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
//    UIWindow *sharewindow = [[UIApplication sharedApplication].delegate window];
//    
//    
//    self.blackView = [[UIView alloc] initWithFrame:self.frame];
//    self.blackView.backgroundColor = [UIColor blackColor];
//    [sharewindow addSubview:self.blackView];
//    
//    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 150, ScreenWidth, 150)];
//    self.shareView.backgroundColor = [UIColor cyanColor];
//    [sharewindow addSubview:self.shareView];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        //微博
//        UIButton *weibobutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        weibobutton.frame = CGRectMake(20, 30, 70, 70);
//        [weibobutton setImage:[UIImage imageNamed:@"sina_login_ic"] forState:UIControlStateNormal];
//        [weibobutton addTarget:self action:@selector(getWeiBoShare) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *weiboL = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 70, 70)];
//        weiboL.text = @"微博分享";
//        [self.shareView addSubview:weiboL];
//        [self.shareView addSubview:weibobutton];
//        
//        //微信朋友
//        UIButton *friendbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        friendbutton.frame = CGRectMake(130, 30, 70, 70);
//        [friendbutton setImage:[UIImage imageNamed:@"icon_pay_weixin"] forState:UIControlStateNormal];
//        [friendbutton addTarget:self action:@selector(getFriendShare) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *weixinL = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 70, 70)];
//        weixinL.text = @"分享给微信好友";
//        [self.shareView addSubview:weixinL];
//        [self.shareView addSubview:friendbutton];
//        //朋友圈
//        UIButton *circlebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        circlebutton.frame = CGRectMake(240, 30, 70, 70);
//        [circlebutton setImage:[UIImage imageNamed:@"py_normal"] forState:UIControlStateNormal];
//        [circlebutton addTarget:self action:@selector(getCircleShare) forControlEvents:UIControlEventTouchUpInside];
//        UILabel *circleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 70, 70)];
//        circleL.text = @"微信朋友圈分享";
//        [self.shareView addSubview:circleL];
//        [self.shareView addSubview:circlebutton];
//        
//        //清除
//        UIButton *removebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        removebutton.frame = CGRectMake(20, 100, ScreenWidth - 40, 44);
//        [removebutton setTitle:@"取消" forState:UIControlStateNormal];
//        [removebutton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
//        [self.shareView addSubview:removebutton];
//    }];
//}
//
//- (WBMessageObject *)messageToshare{
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = @"测试使用";
//    return message;
//}
//
////微博分享
//- (void)getWeiBoShare{
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
//    authRequest.redirectURI = KRedirectURI;
//    authRequest.scope = @"all";
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToshare] authInfo:authRequest access_token:myDelegate.wbtoken];
//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
//    [WeiboSDK sendRequest:request];
}
//- (void)getFriendShare{
//    
//}
//- (void)getCircleShare{
//    
//}
//- (void)getBack{
// 
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
