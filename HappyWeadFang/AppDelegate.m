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
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>   //1  引入框架

@interface AppDelegate ()<WeiboSDKDelegate,WBHttpRequestDelegate,CLLocationManagerDelegate>{
    //全局变量 2  创建所需要的实例对象
    CLLocationManager *_locationManager;
    
    
    //一、创建地理编码对象
    CLGeocoder *_geocoder;
}
@property(nonatomic, strong) WBMessageObject *messageToshare;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //3 初始化定位的对象
    _locationManager = [[CLLocationManager alloc] init];
    
    //4 判断是否打开定位
    if (![CLLocationManager locationServicesEnabled]) {
        FFFLog(@"用户位置服务不用！");
    }
    
    //5 判断是否授权:没有则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //当用户在使用时，打开
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理,在上面引入代理
        _locationManager.delegate = self;
        //设置定位精度:定位精度越精确，越是耗电量
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //定位频率：每个多少米定位一次
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    
    
    //二、初始化地理编码对象
    _geocoder = [[CLGeocoder alloc] init];
    

    
    
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:KAppkey];
    
    //微信
    [WXApi registerApp:KWeiXinAppSecret];
    
    //BMOB
    [Bmob registerWithAppKey:KBmobAppkey];
    
    
    
    //UITabBar
    self.tabbarC = [[UITabBarController alloc] init];
    
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
    _tabbarC.viewControllers = @[mainNav, disNAV, meNAV];
    _tabbarC.tabBar.backgroundColor = [UIColor whiteColor];
    
    //添加为根视图
    self.window.rootViewController = _tabbarC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
  
}
#pragma mark ------------ 定位协议代理
/*
 方法：
 manager      ：当前使用的定位对象
 CLLocation   ：返回定位的数据，是一个数组对象，里边是CLLocation类型
 */
//6
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    FFFLog(@"%@",locations);
    //7  从数组中取出一个定位信息
    CLLocation *location = [locations lastObject];
    //从location中取出坐标 CLLocationCoordinate2D 坐标系，里边包含经度和纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    FFFLog(@"维度：%.6f  经度：%.6f 海拔：%.2f  航向：%.2f  行走速度：%.2f ",coordinate.latitude,coordinate.longitude,location.altitude,location.course,    location.speed);
    
    //三、在获取到用户位置（经纬度）后，通过逆地理编码将经纬度转化为实际的地名、街道等信息
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *city = placemark.addressDictionary[@"City"];
        FFFLog(@"%@",placemark.addressDictionary);
    }];
    //如果不需要使用定位服务的时候，请及时关闭定位
    [_locationManager stopUpdatingLocation];
}

#pragma mark ------------ 微博
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
    
}

#pragma mark ---------- Share Weibo
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    
}


#pragma mark ------------ 请求openAPI


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
