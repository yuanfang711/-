//
//  MainModel.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    RecommendTypeActivity = 1,
    RecommendTypeTheme = 2,
}Recommend;

@interface MainModel : NSObject


//图片
@property(nonatomic, copy) NSString *image_big;
//标题
@property(nonatomic, copy) NSString *title;
//价格
@property(nonatomic, copy) NSString *price;
//经纬度
@property(nonatomic, assign) CGFloat lat;
@property(nonatomic, assign) CGFloat lng;

//活动地址
@property(nonatomic, copy) NSString *address;
//开始时间
@property(nonatomic, copy) NSString *startTime;
//结束时间
@property(nonatomic, copy) NSString *endTime;
//类型
@property(nonatomic, copy) NSString *type;
//次数
@property(nonatomic, copy) NSString *count;
//活动Id
@property(nonatomic, copy) NSString *activityId;
@property(nonatomic, copy) NSString *activityDes;

- (instancetype)initGetCellDictionary:(NSDictionary *)dic;


@end
