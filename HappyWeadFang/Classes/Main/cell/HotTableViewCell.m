//
//  HotTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation HotTableViewCell

- (void)awakeFromNib {
    self.frame = CGRectMake(0, 0, ScreenWidth, 170);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(HotModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headView] placeholderImage:nil];
    self.loveCountLable.text = [NSString stringWithFormat:@"%lu",[model.count integerValue]];
}



@end
