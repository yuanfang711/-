//
//  DiscoverModel.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.headImage = dic[@"image"];
        self.title = dic[@"title"];
        self.discoverId = dic[@"id"];
    }
    return self;
}



@end
