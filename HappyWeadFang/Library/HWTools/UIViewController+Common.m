//
//  UIViewController+Common.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "UIViewController+Common.h"
#import "RegisterViewController.h"

@implementation UIViewController (Common)

- (void)showBackButtonWithImage:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(backButtonActton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = left;

}


-(void)backButtonActton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showRightButtonWithTitle:(NSString *)title{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 64, 44);
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selectWord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnu = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnu;
}
- (void)selectWord{
    RegisterViewController *searchVC =[[RegisterViewController alloc ]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
