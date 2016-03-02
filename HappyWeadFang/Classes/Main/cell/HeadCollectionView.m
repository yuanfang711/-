//
//  HeadCollectionView.m
//  HappyWeadFang
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HeadCollectionView.h"


@interface HeadCollectionView ()
@property (weak, nonatomic) IBOutlet UILabel *cityLable;

@end

@implementation HeadCollectionView

- (IBAction)geoCityButton:(id)sender {
    
}
//
//- (void)awakeFromNib{
//    
//}
//
- (void)setCityDic:(NSDictionary *)cityDic{
    self.cityLable.text = cityDic[@"cat_name"];;
}


@end
