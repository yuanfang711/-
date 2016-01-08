//
//  GoodActivityModel.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodActivityModel : NSObject

@property(nonatomic, strong) GoodActivityModel *model;
//标题
@property(nonatomic, strong) NSString *title;
//图片
@property(nonatomic, strong) NSString *image;
//年龄
@property(nonatomic, strong) NSString *age;
//次数
@property(nonatomic, strong) NSString *count;

@property(nonatomic, strong) NSString *price;

@property(nonatomic, strong) NSString *goodId;

@property(nonatomic, strong) NSString *address;

@property(nonatomic, strong) NSString *type;



- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
