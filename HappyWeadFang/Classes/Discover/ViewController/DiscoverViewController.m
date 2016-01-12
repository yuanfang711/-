//
//  DiscoverViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "ActivityViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    NSInteger _pageCount;
}
@property(nonatomic, strong )PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *allArray;
@property(nonatomic, assign) BOOL refreshing;
@end

@implementation DiscoverViewController

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    

    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil ]forCellReuseIdentifier:@"cell"];
    [self.tableView launchRefreshing];
}
#pragma mark *****************UITableViewDataSource,UITableViewDelegate代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DiscoverModel *model = self.allArray[indexPath.row];
    
    cell.disModel = model;
    return cell;
}
#pragma mark ------------------- 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight ) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setHeaderOnly:YES];
        self.tableView.rowHeight = 100;
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverModel *model = self.allArray[indexPath.row];
    
    UIStoryboard *activity = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityViewController *activityVC = [activity instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    activityVC.activityID = model.discoverId;
//    activityVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:activityVC animated:YES];
    
}
#pragma mark ***************PullingRefreshTableViewDelegate代理
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(getRequest) withObject:nil afterDelay:1.0];
}

-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemTime];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView{
    [self.tableView tableViewDidEndDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}

#pragma mark ------------ 数据请求
- (void)getRequest{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:@"%@",kDiscover] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        [ProgressHUD show:@"正在加载数据…"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载数据成功"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *seccessdic = dic[@"success"];
            NSArray *likeArray = seccessdic[@"like"];
            for (NSDictionary *dis in likeArray) {
                DiscoverModel *model = [[DiscoverModel alloc] initWithDictionary:dis];
                [self.allArray addObject:model];
            }
        }
        //刷新
        [self.tableView reloadData];
        //完成加载
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];
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
