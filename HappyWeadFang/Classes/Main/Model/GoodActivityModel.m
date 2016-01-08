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
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.age = dic[@"age"];
        self.price = dic[@"price"];
        self.type = dic[@"type"];
        self.address = dic[@"address"];
        self.goodId = dic[@"id"];
        self.count = dic[@"count"];
    }
    return self;
}



-(void)setModel:(GoodActivityModel *)model{
    
}



@end
