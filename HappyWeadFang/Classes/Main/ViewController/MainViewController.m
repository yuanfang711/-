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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部数据
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property(nonatomic, strong) NSMutableArray *themeArray;

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
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selectWord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnu = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnu;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil ]forCellReuseIdentifier:@"cell"];
    
    [self configTableViewHeadView];
    
    //请求数据
    [self getModel];
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
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 343;
//    }
//    return 0;
//}


#pragma mark ************   选择城市
- (void)selectCityAction{
    
}

#pragma mark ----------------  搜索关键字
- (void)selectWord{
    
}

#pragma mark  ----------------- 自定义tableview头
- (void)configTableViewHeadView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 343)];
    view.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = view;

}

#pragma mark --------------  请求数据
- (void)getModel{  
    NSString *url = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [managers GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
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
            NSString *cityName = dic[@"cityname"];
            
            //已请求回来的城市作为导航栏的左标题
            self.navigationItem.leftBarButtonItem.title = cityName;

            
        }else{
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
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
