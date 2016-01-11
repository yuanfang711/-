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


@interface ClassifyViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    NSInteger _pageCount;
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
    [self.tableView addSubview:self.vosC];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //第一次进入分类列表中，请求全部的数据
    [self getFourModel];
    //根据上一页选择的按钮，确定显示的是第几页数据
    [self showPreviousSelectResponse];
    
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
    
    
}

#pragma mark *--------------- PullingRefreshTableViewDelegate
//开始刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing =YES;
    [self performSelector:@selector(getFourModel) withObject:nil afterDelay:1.0];
}
//开始加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(getFourModel) withObject:nil afterDelay:1.0];
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

#pragma mark ********** 数据请求（四个接口值）
- (void)getFourModel{
    AFHTTPSessionManager *session  = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //四个请求
    [session GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassActivity,@(1),@(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.showArray addObject:model];
            }
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
    //typeid = 23
    [session GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassActivity,@(1),@(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.tourisArray addObject:model];
            }
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
    
    //typeid = 22
    [session GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassActivity,@(1),@(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.studyArray addObject:model];
            }
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
    
    //typeid = 21
    [session GET:[NSString stringWithFormat:@"%@&page=%@&typeid=%@",kClassActivity,@(1),@(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.familyArray addObject:model];
            }
        }else{
        }
        //
//        [self showPreviousSelectResponse];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
    [self showPreviousSelectResponse];
    //刷新tableview，会重新执行tableview中所有的代理方法
    [self.tableView reloadData];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;

}
- (void)showPreviousSelectResponse{
    if (self.showDataArray.count > 0) {
        [self.showDataArray removeAllObjects];
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
    [self.tableView reloadData];
}


#pragma mark ********** 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-104) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
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
        __block NSInteger index;
          self.classType = index;
        [self.vosC setIndexChangeBlock:^(NSInteger index) {
          
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.vosC addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vosC;
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
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
