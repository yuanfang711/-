//
//  GoodTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleL;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityDesL;
@property (weak, nonatomic) IBOutlet UILabel *activityCount;

@end
@implementation GoodTableViewCell
- (void)setGoodModel:(GoodActivityModel *)goodModel{
    self.activityTitleL.text = goodModel.title; //标题
    //图片
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    //价格
    self.priceLable.text = goodModel.price;
    //次数
    self.activityCount.text = goodModel.count;
    //年龄
    self.ageLable.text = goodModel.age;
    //距离
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
