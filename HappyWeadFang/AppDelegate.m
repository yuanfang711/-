//
//  AppDelegate.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //UITabBar
    UITabBarController *tabbarC = [[UITabBarController alloc] init];
    
//主页
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = main.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *selectedImage = [UIImage imageNamed:@"ft_home_selected_ic.png"];
    //设置选中图片按照图片的原始图片的状态显示
    mainNav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//发现
    UIStoryboard *find = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *disNAV= find.instantiateInitialViewController;
    disNAV.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    disNAV.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //设置选中图片按照图片的原始图片的状态显示
    UIImage *selectedImage2 = [UIImage imageNamed:@"ft_found_selected_ic.png"];
 
    mainNav.tabBarItem.selectedImage = [selectedImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
//我的
    UIStoryboard *me = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *meNAV = me.instantiateInitialViewController;
    meNAV.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic.png"];
    meNAV.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //设置选中图片按照图片的原始图片的状态显示
    UIImage *selectedImage3 = [UIImage imageNamed:@"ft_person_selected_ic.png"];
    
    mainNav.tabBarItem.selectedImage = [selectedImage3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //添加到tabber的视图上
    tabbarC.viewControllers = @[mainNav, disNAV, meNAV];
    tabbarC.tabBar.backgroundColor = [UIColor whiteColor];
    
    //添加为根视图
    self.window.rootViewController = tabbarC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
