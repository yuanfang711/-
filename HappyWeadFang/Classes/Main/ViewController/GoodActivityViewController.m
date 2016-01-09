//
//  GoodActivityViewController.m
//  HappyWeadFang
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodTableViewCell.h"

@interface GoodActivityViewController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate>
@property(nonatomic,assign) BOOL refreshing;
@property(nonatomic, strong) PullingRefreshTableView *tableView;

@end

@implementation GoodActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"精选活动";
    //返回主页的按钮
    [self showBackButton];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark ---------- UITableViewDataSource
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
//分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

#pragma mark ---------- UITableViewDelegate


#pragma mark ---------- PullingRefreshTableViewDelegate
//开始加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}

//开始刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData
) withObject:nil afterDelay:1.0];
}


//刷新完成时间
-(NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemTime];
}

#pragma mark ------- 懒加载
-(PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 64) pullingDelegate:self];
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

#pragma mark ---------- 加载数据
- (void)loadData{
    
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

//下拉刷新开始时调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidScroll:scrollView];
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
