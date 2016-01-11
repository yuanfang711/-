//
//  GoodActivityViewController.m
//  精选活动
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"
#import "GoodActivityModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityViewController.h"

@interface GoodActivityViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>{
    NSInteger _pageCount;
}
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation GoodActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精选活动";
    //返回主页的按钮
    [self showBackButton];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //启动刷新
    [self.tableView launchRefreshing];
}

#pragma mark ---------- 加载数据
- (void)loadData{
    AFHTTPSessionManager *semanage = [[AFHTTPSessionManager alloc] init];
    semanage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [semanage GET:[NSString stringWithFormat:@"%@&page=%lu",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic  = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        NSDictionary *successdic = dic[@"success"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSArray *acArray = successdic[@"acData"];
            //防止数据全部出来后，再次下拉，出现重复数据(需要移除数组中数据)
            if (self.refreshing) {
                //下拉
                if (self.array.count > 0) {
                    [self.array removeAllObjects];
                }
            }
            for (NSDictionary *dis in acArray) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dis];
                [self.array addObject:goodModel];
            }
            //刷新tableview，会重新执行tableview中所有的代理方法
            [self.tableView reloadData];
            [self.tableView tableViewDidFinishedLoading];
            self.tableView.reachedTheEnd = NO;
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

-(NSMutableArray *)array{
    if (_array == nil) {
        self.array = [NSMutableArray new];
    }
    return _array;
}

#pragma mark ---------- UITableViewDataSource
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GoodActivityModel *model = self.array[indexPath.row];
    cell.goodModel = model;
    
    return cell;
}
//分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

#pragma mark ---------- UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityModel *model = self.array[indexPath.row];
    UIStoryboard *stroy =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];;
    ActivityViewController *activityVC = [stroy instantiateViewControllerWithIdentifier:@"activityDetailVC"];
    activityVC.activityID =model.goodId;
    
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark ---------- PullingRefreshTableViewDelegate

//开始刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing =YES;
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
        self.tableView.rowHeight = 90;
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
