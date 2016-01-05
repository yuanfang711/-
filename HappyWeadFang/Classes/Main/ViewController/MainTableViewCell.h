//
//  MainTableViewCell.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;


//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activitynamel;

//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPrice;

//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBu;

@end
