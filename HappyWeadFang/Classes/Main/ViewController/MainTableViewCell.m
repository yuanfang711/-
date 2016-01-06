//
//  MainTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityIamhe;
//活动名字

@property (weak, nonatomic) IBOutlet UILabel *acticityName;

//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;

//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBu;
@end

@implementation MainTableViewCell

- (void)awakeFromNib {

}

- (void)setModel:(MainModel *)model{
    
    if ([model.type floatValue] == RecommendTypeActivity) {
        self.activityDistanceBu.hidden = NO;
    }else {
        self.activityDistanceBu.hidden = YES;
    }
    
    [self.activityIamhe sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.acticityName.text = model.title;
//    [self.activityDistanceBu setTitle:model.activityDes forState:UIControlStateNormal];
    self.activityPrice.text = model.price;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
