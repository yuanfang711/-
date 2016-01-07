//
//  AcyivityDetailView.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "AcyivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface AcyivityDetailView ()
{
    //保存上次图片的高度
    CGFloat _PreviousImageHeight;
    //上次图片的高度
    CGFloat _PreviousImageHight;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleL;


@property (weak, nonatomic) IBOutlet UILabel *activityTimeL;



@property (weak, nonatomic) IBOutlet UILabel *favouriteL;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceL;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UILabel *activityAddressL;

@property (weak, nonatomic) IBOutlet UILabel *activityPhoneNumL;
@end

@implementation AcyivityDetailView

-(void)awakeFromNib{
    
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, 5000);
    [self addSubview:self.mainScrollView];
}

- (void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urlS = dataDic[@"urls"];
    
    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:urlS[0]] placeholderImage:nil];

    //活动标题
    self.activityTitleL.text = dataDic[@"title"];
    //活动时间
    NSString *timer = [HWTools getDataFromString:dataDic[@"new_start_date"]];
    NSString *endT =[HWTools getDataFromString:dataDic[@"new_end_date"]];
    self.activityTimeL.text = [NSString stringWithFormat:@"正在进行：%@ -- %@",timer,endT];
    
    //活动收场
    self.favouriteL.text = [NSString stringWithFormat:@"%@人喜欢",dataDic[@"fav"]];
    //活动价格
    self.activityPriceL.text = dataDic[@"pricedesc"];
    //活动地址
    self.activityAddressL.text = dataDic[@"address"];
    //电话
    self.activityPhoneNumL.text = dataDic[@"tel"];

    //活动详情
    [self drawWithArray:dataDic[@"content"]];

}
- (void)drawWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(ScreenWidth, 1000)  textFont:15.0];
        CGFloat y;
        //防止开始时第一个lable从0开始，固定从500开始。
        /*
         如果从底部的高度没有值（也就是小于500），也就说明是加载第一个lable，那么y的值，就不应该减去500；
         */
        if (_PreviousImageHeight > 500) {
            y = 500 + _PreviousImageHeight -500;
        }else{
            y = 500 + _PreviousImageHeight;
        }
        //标题
//        NSString *title =dic[@"title"];
        
//        if (title != nil) {
//            //如果标题存在，
//            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth -20, 30)];
//            titleL.text = title;
//            [self.mainScrollView addSubview:titleL];
//            y +=30;
//        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        NSArray *urlsArray = dic[@"urls"];
        //如果没有图片时，上次的图片的高度用上次的lable的地步 + 10
        if (urlsArray == nil) {
            _PreviousImageHeight = label.bottom +10;
        }else{
            for (NSDictionary *urlDis in urlsArray) {
                CGFloat imageHight;
                if(urlsArray.count > 1)
                {
                    //多张图片的使用
                    imageHight = label.bottom + _PreviousImageHight;
                }else{
                    //单张图片的使用
                    imageHight = label.bottom;
                }
                CGFloat width = [urlDis[@"width"] integerValue];
                CGFloat imageHeight = [urlDis[@"height"] integerValue];
    
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom, ScreenWidth - 20, (ScreenWidth - 20)/width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDis[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _PreviousImageHeight = imageView.bottom;
            }
            
        }
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
