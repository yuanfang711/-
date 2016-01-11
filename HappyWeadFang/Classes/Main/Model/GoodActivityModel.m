//
//  GoodActivityModel.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodActivityModel.h"

@implementation GoodActivityModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        //标题
        self.title = dic[@"title"];
        //头图片
        self.image = dic[@"image"];
        //年龄
        self.age = dic[@"age"];
        //价格
        self.price = dic[@"price"];
        //类型
        self.type = dic[@"type"];
        //地址
        self.address = dic[@"address"];
        //id号
        self.goodId = dic[@"id"];
        //赞的次数
        self.count = dic[@"counts"];
    }
    return self;
}


@end
