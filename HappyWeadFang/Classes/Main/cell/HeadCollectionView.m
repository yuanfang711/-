//
//  HeadCollectionView.m
//  HappyWeadFang
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HeadCollectionView.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation HeadCollectionView

- (void)setCityDic:(NSDictionary *)cityDic{
    self.cityLable.text = cityDic[@"cat_name"];
}
@end
