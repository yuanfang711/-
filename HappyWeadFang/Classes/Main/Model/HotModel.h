//
//  HotModel.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotModel : NSObject
//图片
@property(nonatomic, strong) NSString *headView;
//id
@property(nonatomic, strong) NSString *hotid;

@property(nonatomic, strong) NSString *count;

@property(nonatomic, strong) NSString *title;
- (instancetype)initWithDestionary:(NSDictionary *)dic;

@end
