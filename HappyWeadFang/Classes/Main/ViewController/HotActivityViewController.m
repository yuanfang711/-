//
//  HotActivityViewController.m
//  热门专题
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "HotActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "HotTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeViewViewController.h"

@interface HotActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *allArray;

@end

@implementation HotActivityViewController
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //标题
    self.title = @"活动专题";
    
//    [self loadData];
    
    //返回按钮
    [self showBackButton];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HotTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotcell"];
    //启动刷新
    [self.tableView launchRefreshing];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}

#pragma mark ---------- 加载数据
- (void)loadData{
    AFHTTPSessionManager *semanage = [[AFHTTPSessionManager alloc] init];
    semanage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [semanage GET:[NSString stringWithFormat:@"%@&page=%lu",kHotActivityThem,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        //防止数据全部出来后，再次下拉，出现重复数据(需要移除数组中数据)
        if (self.refreshing) {
            //下拉
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }
        }
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"rcData"];
            for (NSDictionary *dis in acArray) {
                HotModel *hotModel = [[HotModel alloc] initWithDestionary:dis];
                [self.allArray addObject:hotModel];
            }
            //刷新tableview，会重新执行tableview中所有的代理方法
            [self.tableView reloadData];
            //完成加载
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark ---------- UITableViewDataSource
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"hotcell" forIndexPath:indexPath];
    HotModel *model = self.allArray[indexPath.row];
    cell.model = model;
    return cell;
}

//分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}

#pragma mark ---------- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotModel *model = self.allArray[indexPath.row];
    ThemeViewViewController *themeVC=  [[ThemeViewViewController alloc] init];
    themeVC.themeId = model.hotid;
    themeVC.title = model.title;
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark ---------- PullingRefreshTableViewDelegate
//开始刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//开始加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

//刷新完成时间
-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemTime];
}

#pragma mark ------- 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 64) pullingDelegate:self];
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        self.tableView.rowHeight = 180;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
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
