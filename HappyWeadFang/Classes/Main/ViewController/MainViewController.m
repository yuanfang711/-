//
//  MainViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "MainViewController.h"
#import "MainModel.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectViewController.h"
#import "SearchViewController.h"
#import "ActivityViewController.h"
#import "ThemeViewViewController.h"
#import "ClassifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"



@interface MainViewController ()<UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部数据
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property(nonatomic, strong) NSMutableArray *themeArray;
@property(nonatomic, strong) NSMutableArray *idArray;

//滚动条
@property(nonatomic, strong) UIScrollView *scrollV;
@property(nonatomic, strong) UIPageControl *pageC ;

//定时器播放动画
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) UIView *headView;

@property(nonatomic, strong) UIButton *activityBtn;
@property(nonatomic, strong) UIButton *themeBtn;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0/255.0 green:181.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    //设置北京
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"上海" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    leftBtn.tintColor = [UIColor whiteColor];
    
    
    //搜索按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 22, 22);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selectWord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnu = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnu;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil ]forCellReuseIdentifier:@"cell"];
    
    [self configTableViewHeadView];
    
    //请求数据
//    [self getModel];
    [self startTimer];

}


#pragma mark ****----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    else
        return self.themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *group = self.listArray[indexPath.section];
    
    cell.model = group[indexPath.row];

    return cell;
}
#pragma mark ***-------UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 160, 5,320, 16)];
    UIImage *images = [[UIImage alloc] init];
    if (section == 0) {
        images = [UIImage imageNamed:@"home_recommed_ac.png"];
        imageView.backgroundColor = [UIColor colorWithPatternImage:images];
        
    }else if(section == 1){
        images = [UIImage imageNamed:@"home_recommd_rc.png"];
        imageView.backgroundColor = [UIColor colorWithPatternImage:images];
    }
    [view addSubview:imageView];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *model = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *activity = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ActivityViewController *activityVC = [activity instantiateViewControllerWithIdentifier:@"activityDetailVC"];
        activityVC.activityID = model.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewViewController *themeVC= [[ThemeViewViewController alloc] init];
        themeVC.themeId = model.activityId;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}


#pragma mark ************   选择城市
- (void)selectCityAction{
    SelectViewController *select = [[SelectViewController alloc] init];
    [self.navigationController presentViewController:select animated:YES completion:nil];
}

#pragma mark ----------------  搜索关键字
- (void)selectWord{
    SearchViewController *searchVC =[[SearchViewController alloc ]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark  ----------------- 自定义tableview头
- (void)configTableViewHeadView{
    //轮播图
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 343)];
    
    [self.headView addSubview:self.scrollV ];
      self.pageC.numberOfPages = self.idArray.count;
    [self.headView addSubview:self.pageC];

    
    for (int i = 0 ; i < self.idArray.count; i++) {
        
        UIImageView *iamgeview = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, 186)];
        
        [iamgeview sd_setImageWithURL:[NSURL URLWithString:self.idArray[i][@"url"]] placeholderImage:nil];
        
        //打开用户交互
        self.headView.userInteractionEnabled = YES;
        
        [self.scrollV  addSubview:iamgeview];

        //用户交hu
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = iamgeview.frame ;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(TouchAdvertisement:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollV addSubview:button];
        
    }
    
    
     //4个按钮
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * ScreenWidth/4 , 186, ScreenWidth/4 - 5, (343 - 186 ) / 2);
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_icon_%02d",i +1]] forState:UIControlStateNormal];
        button.tag = 100 +i;
        [button addTarget:self action:@selector(mainActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:button];
        
       
    }
    
    
    //精选活动、专题
    [self.headView addSubview:self.activityBtn];
    
    [self.headView addSubview:self.themeBtn];
    
    self.tableView.tableHeaderView = self.headView;
   
}
- (UIScrollView *)scrollV{
    if (_scrollV == nil) {
        self.scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 186)];
        
        self.scrollV.delegate = self;
        
        self.scrollV .contentSize = CGSizeMake(self.idArray.count*ScreenWidth, 186);
        
        //整屏滑动
        self.scrollV .pagingEnabled = YES;
        
        //是否显示水平滚动条；
        self.scrollV .showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollV;
}

- (UIPageControl *)pageC{
    if (_pageC == nil) {
        //创建小圆点
        self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 186 -30, ScreenWidth, 30)];
//        self.pageC.backgroundColor = [UIColor redColor];
        
        self.pageC.currentPageIndicatorTintColor = [UIColor cyanColor];
        
        [self.pageC addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageC;
}

- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0,186 + (343 - 186 ) / 2, ScreenWidth/2, (343 - 186 ) / 2);
        self.activityBtn.tag = 105;
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        [self.activityBtn addTarget:self action:@selector(goodActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityBtn;
}
- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(ScreenWidth/2,186 + (343 - 186 ) / 2, ScreenWidth/2, (343 - 186 ) / 2);
        self.themeBtn.tag = 106;
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        [self.themeBtn addTarget:self action:@selector(HotActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _themeBtn;
}
#pragma mark ------------- 定时器设置
- (void)startTimer{
    
    //如果定时器存在的话， 不在执行
    if (_timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollScreen) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
//每两秒执行一次图片自动轮播
- (void)rollScreen{
    if (self.idArray.count > 0) {
        //当前页 +1
        //self.idArray.count的元素可能为0，当0时对取余的时候，没有意义
        NSInteger rollPage = (self.pageC.currentPage + 1) % self.idArray.count;
        self.pageC.currentPage = rollPage;
        
        CGFloat offset = rollPage * ScreenWidth;
        [self.scrollV setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
}

//当手动滑动scrollview的时候，定时器仍然在计算时间，可能我们刚滑动到下一页，定时器时间刚好有触发，导致当前页面停留不足两秒；
//解决方案：在scrollview开始移动的时候结束定时器；
//移动完毕开启定时器；

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self rollScreen];
    //停止定时器后，将定时器置为nil，再次启动时，定时器才能保证正常执行。
//    self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}


#pragma mark --------------  请求数据
- (void)getModel{  
    NSString *url = kMainDataList;
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managers GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        
        NSDictionary *diction = responseObject;
        NSString *status = diction[@"status"];
        NSInteger code = [diction[@"code"] floatValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = diction[@"success"];
            //推荐活动
            NSArray *acArray = dic[@"acData"];
            
            for (NSDictionary *dis in acArray) {
                MainModel *model = [[MainModel alloc] initGetCellDictionary:dis];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            
            //推荐专题
            NSArray *rcArray = dic[@"rcData"];
            for (NSDictionary *dis in rcArray) {
                MainModel *model = [[MainModel alloc] initGetCellDictionary:dis];
                
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新
            [self.tableView reloadData];
            
            //广告
            NSArray *adArray = dic[@"adData"];
            for (NSDictionary *dis in adArray) {
                NSDictionary *dic = @{@"url":dis[@"url"],@"type":dis[@"type"],@"id":dis[@"id"]};
                [self.idArray addObject:dic];
            }
//            [self startTimer];
            //拿到数据后，重新刷新
            [self configTableViewHeadView];
            NSString *cityName = dic[@"cityname"];
            //已请求回来的城市作为导航栏的左标题
            self.navigationItem.leftBarButtonItem.title = cityName;
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
}
#pragma mark ------------------- 懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}


- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
}

#pragma mark --------------- 4个button、精选、热门的点击方法
//点击广告
- (void)TouchAdvertisement:(UIButton *)button{
    //从字典里取出type类型
    NSString *type = self.idArray[button.tag - 100][@"type"];
    if ([type floatValue] == 1) {
        
        UIStoryboard *activity = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ActivityViewController *activityVC = [activity instantiateViewControllerWithIdentifier:@"activityDetailVC"];
        activityVC.activityID = self.idArray[button.tag - 100][@"id"];
        activityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewViewController *themeVC = [[ThemeViewViewController alloc] init];
        themeVC.themeId = self.idArray[button.tag - 100][@"id"];
        themeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

//分类列表
- (void)mainActivityButtonAction{
    ClassifyViewController *classVC = [[ClassifyViewController alloc] init];
    classVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classVC animated:YES];
}

//精选活动
- (void)goodActivityButtonAction{
    GoodActivityViewController *goodVC = [[GoodActivityViewController alloc] init];
    goodVC.hidesBottomBarWhenPushed= YES;
    [self.navigationController pushViewController:goodVC animated:YES];
}

//热门专题
- (void)HotActivityButtonAction{
    HotActivityViewController *hotVC = [[HotActivityViewController alloc] init];
    hotVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotVC animated:YES];
}

#pragma mark --------------- 首页轮播图的小圆点
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scroll页面的宽度
    CGFloat pageWidth = self.scrollV.frame.size.width;
    
    //第二步：获取scrollView停止时的偏移量
    CGPoint offset = self.scrollV.contentOffset;
    
    //第三部：通过偏移量和页面宽度计算当前页数
    NSInteger num = offset.x / pageWidth;
    self.pageC.currentPage = num;
}

- (void)pageAction:(UIPageControl *)pageC{
    //1获取PageControl点击的页面在第几页
    NSInteger num =  pageC.currentPage ;
    
    //2、获取页面的宽度，
    CGFloat pagef = self.scrollV.frame.size.width;
    
    //3、让scrollview滚动到第几页
    self.scrollV.contentOffset = CGPointMake(num * pagef, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
