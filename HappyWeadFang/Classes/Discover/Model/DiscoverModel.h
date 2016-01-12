//
//  DiscoverModel.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject

@property(nonatomic, strong) NSString *headImage;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *discoverId;


-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
