//
//  HWTools.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools



+(NSString *)getDataFromString:(NSString *)timeStamp{
    NSTimeInterval time = [timeStamp doubleValue];
    NSDate *nowDate =[[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy.MM.dd"];
    NSString *timer = [date stringFromDate:nowDate];
    return timer;
}



+(CGFloat)getTextHeightWithBigestSize:(NSString *)text BigestSize:(CGSize)bigSize textFont:(CGFloat)textfont{

    CGRect rect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:textfont]} context:nil];
    return rect.size.height;
}




@end
