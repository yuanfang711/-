//
//  DiscoverTableViewCell.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbale;

@end

@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDisModel:(DiscoverModel *)disModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:disModel.headImage] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 45;
    self.headImageView.clipsToBounds = YES;
    
    self.titleLbale.text = disModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
