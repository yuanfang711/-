//
//  SelectViewController.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityBackNameDelegate <NSObject>
//block传值
//- (void)getCityBackWithArray:(NSArray *)cityA Name:(void(^)(NSString *cityName))nameBlock;
//代理传值
- (void)getCityBackName:(NSString *)cityName AndCityId:(NSString *)cityid;
@end

@interface SelectViewController : UIViewController


@property(nonatomic, assign) id<CityBackNameDelegate>cityDelegate;

@end
