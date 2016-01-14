//
//  ClassifyViewController.m
//  分类列表
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityViewController.h"
#import "ProgressHUD.h"

@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    NSInteger _pageCount;   //请求的页数
}
@property(nonatomic, strong) VOSegmentedControl *vosC;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;

//用来显示的数组
@property(nonatomic, strong) NSMutableArray *showDataArray;
@property(nonatomic, strong) NSMutableArray *showArray; //演出剧目
@property(nonatomic, strong) NSMutableArray *tourisArray; //景点剧场
@property(nonatomic, strong) NSMutableArray *studyArray;//学习益智
@property(nonatomic, strong) NSMutableArray *familyArray;//亲子旅游
@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分类列表";
    [self showBackButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.vosC];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //第一次进入分类列表中，请求全部的数据
    [self getShowModel];
    [self getTourieModel];
    [self getStudyModel];
    [self getFamilyModel];
    _pageCount = 1;
    
    //选择是哪个请求
    [self chooseResques];
}
//在页面将要消失的时候，调用此方法，去掉所有的
-(void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}

#pragma mark *--------------- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    cell.goodModel = model;
    
    return cell;
}
#pragma mark *--------------- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    UIStoryboard *activity = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityViewController *activityVC = [activity instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    activityVC.activityID =model.goodId;
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark *--------------- PullingRefreshTableViewDelegate
//开始刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing =YES;
    [self performSelector:@selector(chooseResques) withObject:nil afterDelay:1.0];
}
//开始加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseResques) withObject:nil afterDelay:1.0];
}

//刷新完成时间
-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemTime];
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ********** 数据请求（四个接口）
- (void)getShowModel{
    AFHTTPSessionManager *session  = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //
    [ProgressHUD show:@"拼命加载中…"];
    //请求
    [session GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassActivity,_pageCount,@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功！"];
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            if(_refreshing){
                if (self.showArray.count >0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.showArray addObject:model];
            }
        }else{
        }
        //根据上一页选择的按钮，确定显示的是第几页数据
        [self showPreviousSelectResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getTourieModel{
    AFHTTPSessionManager *session  = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"数据加载中…"];
    //请求
    [session GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassActivity,_pageCount,@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载成功"];
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            if(_refreshing){
                if (self.tourisArray.count >0) {
                    [self.tourisArray removeAllObjects];
                }
            }
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.tourisArray addObject:model];
            }
        }else{
        }
        //根据上一页选择的按钮，确定显示的是第几页数据
        [self showPreviousSelectResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getStudyModel{
    AFHTTPSessionManager *session  = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"数据加载中…"];
    //四个请求
    [session GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassActivity,_pageCount,@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据成功"];
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            if(_refreshing){
                if (self.studyArray.count >0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.studyArray addObject:model];
            }
        }else{
        }
        //根据上一页选择的按钮，确定显示的是第几页数据
        [self showPreviousSelectResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getFamilyModel{
    AFHTTPSessionManager *session  = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"数据加载中…"];
    //请求
    [session GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@",kClassActivity,_pageCount,@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功！"];
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            if(_refreshing){
                if (self.familyArray.count >0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.familyArray addObject:model];
            }
        }else{
        }
        //根据上一页选择的按钮，确定显示的是第几页数据
        [self showPreviousSelectResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)chooseResques{
    switch (self.classType) {
        case ClassifyListTypeShowRepertorie:{
            [self getShowModel];
        }break;
        case ClassifyListTypeTourisePlace:{
            [self getTourieModel];
        }break;
        case ClassifyListTypeStudyPUZ:{
            [self getStudyModel];
        }break;
        case ClassifyListTypeFamilyTravel:{
            [self getFamilyModel];
        }break;
        default:break;
    }
}

- (void)showPreviousSelectResponse{
    if(_refreshing){         //下拉刷新时，需要删除原来的数据
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classType) {
        case ClassifyListTypeShowRepertorie:{
            self.showDataArray = self.showArray;
        }break;
        case ClassifyListTypeTourisePlace:{
            self.showDataArray = self.tourisArray;
        }break;
        case ClassifyListTypeStudyPUZ:{
            self.showDataArray = self.studyArray;
        }break;
        case ClassifyListTypeFamilyTravel:{
            self.showDataArray = self.familyArray;
        }break;
        default:break;
    }
    //完成加载
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
    [self.tableView reloadData];
}

#pragma mark ********** 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-100) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 90;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}

-(VOSegmentedControl *)vosC{
    if (_vosC == nil) {
        self.vosC = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点剧场"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"},]];
        self.vosC.contentStyle = VOContentStyleTextAlone;
        self.vosC.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.vosC.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.vosC.selectedBackgroundColor = self.vosC.backgroundColor;
        self.vosC.allowNoSelection = NO;
        self.vosC.frame = CGRectMake(0, 0, ScreenWidth, 40);
        self.vosC.indicatorThickness = 4;
        self.vosC.selectedSegmentIndex = self.classType - 1;
        [self.view addSubview:self.vosC];
        
        //点击返回是哪个按钮
        [self.vosC setIndexChangeBlock:^(NSInteger index) {
        }];
        [self.vosC addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vosC;
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    self.classType = segmentCtrl.selectedSegmentIndex;
    [self chooseResques];
}

-(NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

-(NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (NSMutableArray *)tourisArray{
    if (_tourisArray == nil) {
        self.tourisArray = [NSMutableArray new];
    }
    return _tourisArray;
}

- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}

- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
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
