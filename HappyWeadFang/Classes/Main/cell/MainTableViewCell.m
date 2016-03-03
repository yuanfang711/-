//
//  MainTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CLLocation.h>

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
    //计算两个经纬度的距离
    double org = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat"] intValue];
    double lng = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lng"] intValue];
    CLLocation *orgLocation = [[CLLocation alloc] initWithLatitude:org longitude:lng];
    
    CLLocation *reLocation = [[CLLocation alloc] initWithLatitude:model.lat longitude:model.lng];
    
    CLLocationDirection dierction = [orgLocation distanceFromLocation:reLocation]/1000;
//    FFFLog(@"%.2f",dierction);
    
    if ([model.type floatValue] == RecommendTypeActivity) {
        self.activityDistanceBu.hidden = NO;
    }else {
        self.activityDistanceBu.hidden = YES;
    }
    [self.activityIamhe sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.acticityName.text = model.title;
    
    [self.activityDistanceBu setTitle:[NSString stringWithFormat:@"%.2fkm",dierction] forState:UIControlStateNormal];
    self.activityPrice.text = model.price;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
