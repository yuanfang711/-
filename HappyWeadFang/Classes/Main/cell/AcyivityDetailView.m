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
    
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth, 4000);
    
    
//    [self addSubview:self.mainScrollView];
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
- (void)drawWithArray:(NSArray *)contentArray {
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(ScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_PreviousImageHeight > 385) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 385 + _PreviousImageHeight - 385;
        } else {
            y = 385 + _PreviousImageHeight;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];

        _PreviousImageHight = label.bottom +10;
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _PreviousImageHeight = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _PreviousImageHeight + label.height +35;
                        } else {
                            imgY = _PreviousImageHeight+ label.height + 5 ;
                        }
                    } else {
                        imgY = lastImgbottom + 10;
                    }
                    
                } else {
                    //单张图片的情况
                    imgY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgY, ScreenWidth - 20, (ScreenWidth - 20)/width * imageHeight)];
                imageView.backgroundColor = [UIColor redColor];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _PreviousImageHeight = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
            }
        }
        //保留最后一个label的高度(就是scrollView)，+ 30是下边tabbar的高度
        _PreviousImageHight = label.bottom > _PreviousImageHeight? label.bottom+70:_PreviousImageHeight+70;
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
