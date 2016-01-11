//
//  HotTableViewCell.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"
@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *loveCountLable;

@property(nonatomic,strong) HotModel *model;

@end
