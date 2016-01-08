//
//  GoodActivityViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>


@interface GoodActivityViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount; //请求的页码
}
@property(nonatomic, strong) PullingRefreshTableView *tableview;

@property(nonatomic, assign) BOOL refreshing;

@end

@implementation GoodActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"精选活动";
    
    [self showBackButton];
    
    //注册cell
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
}

#pragma mark ----------  UITableViewDataSource
//分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

//cell显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodActivityTableViewCell *goodcell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    goodcell.contentView.backgroundColor = [UIColor redColor];
    return goodcell;
    
}

#pragma mark ----------  UITableViewDelegate
//点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark --------------- PullingRefreshTableViewDelegate
//开始下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
}

//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{

    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount += 1;
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    //创建一个NSDataFormatter显示刷新时间
    return [HWTools getSystemTime];
    
}

#pragma mark ---------------- ScrollView两个方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableview tableViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableview tableViewDidEndDragging:scrollView];
}

#pragma mark ----- 加载数据
//加载数据
- (void)loadData{
    FFFLog(@"sadss");
    
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc] init];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [session GET:[NSString stringWithFormat:@"%@&id=%ld",kGoodActivity,_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    [self.tableview tableViewDidFinishedLoading];
    self.tableview.reachedTheEnd = NO;
    
}

#pragma mark --------------- LazyLoading
-(PullingRefreshTableView *)tableview{
    if (_tableview == nil) {
        self.tableview = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight -64) pullingDelegate:self];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        self.tableview.rowHeight = 90;
    }
    return _tableview;
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
