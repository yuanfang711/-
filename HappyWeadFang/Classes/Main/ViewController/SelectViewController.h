//
//  SelectViewController.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityBackNameDelegate <NSObject>

- (void)getCityBack:(NSString *)name WithCityID:(NSString *)cityID;

@end

@interface SelectViewController : UIViewController


@property(nonatomic, assign) id<CityBackNameDelegate>cityDelegate;

@end
