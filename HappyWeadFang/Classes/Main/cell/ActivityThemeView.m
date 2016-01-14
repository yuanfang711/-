//
//  ActivityThemeView.m
//  活动专题视图
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityThemeView (){
    CGFloat _previousImageBottom;
    CGFloat _lastLabelBottom;
}
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ActivityThemeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

//自定义视图
- (void)configView{
    
    [self.scrollView addSubview:self.headImageView];
    [self addSubview:self.scrollView];
}
#pragma mark ---------scrollView、headImageView 懒加载
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        //
//        self.scrollView.contentSize = CGSizeMake(ScreenWidth, 10000);
    }
    return _scrollView;
}
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 186)];

        
    }
    return _headImageView;
}

#pragma mark --------- 在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    //活动详情
    [self drawWithArray:dataDic[@"content"]];
     self.scrollView.contentSize = CGSizeMake(ScreenWidth, _lastLabelBottom);
    
}


- (void)drawWithArray:(NSArray *)contentArray {
    for (NSDictionary *dic in contentArray) {
        //每一段活动信息
        CGFloat height = [HWTools getTextHeightWithBigestSize:dic[@"description"] BigestSize:CGSizeMake(ScreenWidth, 1000) textFont:15.0];
        CGFloat y;
        if (_previousImageBottom > 186) { //如果图片底部的高度没有值（也就是小于500）,也就说明是加载第一个lable，那么y的值不应该减去500
            y = 186 + _previousImageBottom - 186;
        } else {
            y = 186 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        if (title != nil) {
            //如果标题存在,标题的高度应该是上次图片的底部高度
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.scrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.scrollView addSubview:label];
        //保留最后一个label的高度，+ 64是下边tabbar的高度
        _lastLabelBottom = label.bottom + 10 + 64;

        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) { //当某一个段落中没有图片的时候，上次图片的高度用上次label的底部高度+10
            _previousImageBottom = label.bottom + 10;
        } else {
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlsArray) {
                CGFloat imgY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) { //有title的算上title的30像素
                            imgY = _previousImageBottom + label.height + 30 + 5;
                        } else {
                            imgY = _previousImageBottom + label.height + 5;
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
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.scrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
 
            }
        }
        //保留最后一个label的高度(就是scrollView)，+ 30是下边tabbar的高度
        _lastLabelBottom = label.bottom > _previousImageBottom? label.bottom+ 70:_previousImageBottom + 70;
    }
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, _lastLabelBottom + 20);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
