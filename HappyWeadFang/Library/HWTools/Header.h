//
//  Header.h
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertorie = 1, //演出剧目
    ClassifyListTypeTourisePlace,       //景点场馆
    ClassifyListTypeStudyPUZ,           //学习益智
    ClassifyListTypeFamilyTravel,       //亲子旅游
};

#ifndef Header_h
#define Header_h

#define kColor [UIColor colorWithRed:96.0/255.0 green:185.0/255.0 blue:191.0/255.0 alpha:1.0]

//将所有的接口都放到header中定义
//主页接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=141&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"

//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"

//竞选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=1&type=1"

//热门专题接口
#define kHotActivityThem @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942"

//分类列表接口
#define kClassActivity @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"
//发现接口
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

//发现接口
#define kCity @"http://e.kumi.cn/app/citylist.php?_s_=7afdcf70cf8f62146f2387946b4bf4e0&_t_=1456798700&channelid=appstore&cityid=1316&lat=34.61346589895142&lng=112.4140820306375"


//新浪微博分享
#define KAppkey  @"4041993732"
#define KAppSecret @"ae76250cee9bbea1780caad271bc8ac"
#define KRedirectURI @"https://api.weibo.com/oauth2/default.html"

//微信分享
#define KWeiXinAppId  @"wx34291138bd3bb5af"
#define KWeiXinAppSecret @"ba33483856ce55f7dbffb7f0d1a19940"
#define KBmobAppkey     @"cf6870ee91d7e6b5fd6359d3c596487b"

#endif /* Header_h */
