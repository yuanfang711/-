//
//  HWTools.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

#pragma mark *----------- 时间转换的相关方法

+(NSString *)getDataFromString:(NSString *)timeStamp;//通过时间戳

#pragma mark *----------- 根据文字最大显示的匡高和文字内容返回文字高度

+(CGFloat )getTextHeightWithBigestSize:(NSString *)text BigestSize:(CGSize )bigSize textFont:(CGFloat)textfont;


@end
