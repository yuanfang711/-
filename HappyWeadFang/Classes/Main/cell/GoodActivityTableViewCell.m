//
//  GoodActivityTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodActivityTableViewCell.h"

@interface GoodActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headInageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleL;
@property (weak, nonatomic) IBOutlet UILabel *activityDesL;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAge;
@property (weak, nonatomic) IBOutlet UILabel *ageL;

@property (weak, nonatomic) IBOutlet UILabel *activityPriceL;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@end

@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, ScreenHeight, 90);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
