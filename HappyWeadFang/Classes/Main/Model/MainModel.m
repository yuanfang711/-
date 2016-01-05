//
//  MainModel.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
-(instancetype)initGetCellDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        if ([_type floatValue] == RecommendTypeActivity) {
            //推荐活动
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.count = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
        }
        else{
            //推荐专题
            self.activityDes = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];
    }
    return self;
}



@end
