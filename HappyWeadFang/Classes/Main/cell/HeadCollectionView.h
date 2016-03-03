//
//  HeadCollectionView.h
//  HappyWeadFang
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadCollectionView : UICollectionReusableView
//定位后的城市
@property (weak, nonatomic) IBOutlet UILabel *cityLable;
//重新定位
@property (weak, nonatomic) IBOutlet UIButton *reLocationButton;

@property(nonatomic, strong) NSDictionary *cityDic;

@end
