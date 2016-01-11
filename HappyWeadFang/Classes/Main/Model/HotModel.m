//
//  HotModel.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel

-(instancetype)initWithDestionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.headView = dic[@"img"];
        self.hotid = dic[@"id"];
        self.count = dic[@"counts"];
        self.title = dic[@"title"];
    }
    return self;
}
@end
