//
//  SelectViewController.m
//  搜索城市
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 范芳芳. All rights reserved.
//

#import "SelectViewController.h"
#import "HeadCollectionView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <CoreLocation/CoreLocation.h>
#import "ProgressHUD.h"

static NSString *headItem = @"HeadIdentifier";
static NSString *itemIdentifier = @"itemIdentifier";

@interface SelectViewController ()<UICollectionViewDataSource,UIBarPositioningDelegate,UICollectionViewDelegateFlowLayout,CLLocationManagerDelegate>{
      CLLocationManager *_location;
      CLGeocoder *_gelacotion;
}

@property(strong,nonatomic) UICollectionView *collectView;
@property(nonatomic, strong) NSMutableArray *cityArray;
@property(nonatomic, strong) HeadCollectionView *headView;
@property(nonatomic, strong) NSMutableArray *cityIdArray;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"切换城市";
    self.navigationController.navigationBar.barTintColor = kColor;
    [self showBackButtonWithImage:@"camera_cancel_up"];
    [self.view addSubview:self.collectView];
    [self getCityData];
}

- (void)viewDidAppear:(BOOL)animated{
    [ProgressHUD dismiss];
}

#pragma mark ----------- 懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        //
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直
        layout.scrollDirection =UICollectionViewScrollDirectionVertical;
        //每一个的item的间距
        layout.minimumInteritemSpacing = 0.1;
        //每一行的间距
        layout.minimumLineSpacing = 2;
        //设置item整体在屏幕的位置
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //区头的大小
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 137);
        //每个设置的大小为
        layout.itemSize = CGSizeMake(ScreenWidth/3 - 5, ScreenWidth/10 + 20);
        //通过layout布局来创建一个collection
        _collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        //设置代理
        _collectView.delegate = self;
        _collectView.dataSource = self;
        //将原背景颜色消除
        _collectView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:0.5];
        //注册item类型，与下item的设置要一致
        [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        //注册区头
        [self.collectView registerNib:[UINib nibWithNibName:@"HeadCollectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headItem];
    }
    return _collectView;
}
- (HeadCollectionView *)headView{
    if (_headView == nil) {
        _headView = [[HeadCollectionView alloc] init];
    }
    return _headView;
}
- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
- (NSMutableArray *)cityIdArray{
    if (_cityIdArray == nil) {
        self.cityIdArray = [NSMutableArray new];
    }
    return _cityIdArray;
}

#pragma mark *******数据请求
- (void)getCityData{
    AFHTTPSessionManager *cityManager = [AFHTTPSessionManager manager];
    cityManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"数据加载中……"];
    [cityManager GET:kCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"完成！"];
        NSDictionary *Dic = responseObject;
        NSString *code = Dic[@"code"];
        NSString *status = Dic[@"status"];
        if ([status isEqualToString:@"success"] && [code intValue] == 0) {
            NSDictionary *group = Dic[@"success"];
            NSArray *list  = group[@"list"];
            for (NSDictionary *dic in list) {
                  [self.cityArray addObject:dic[@"cat_name"]];
                [self.cityIdArray addObject:dic[@"cat_id"] ];
            }
            [self.collectView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FFFLog(@"%@",error);
    }];;
}

#pragma mark ------   重写back的方法
-(void)backButtonActton:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark **-----------代理
//共有多少个分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//个分区中有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityArray.count;
}

//设置item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath ];
    
    cell.backgroundColor = [UIColor whiteColor];

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3 - 5, ScreenWidth/10 + 20)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
    lable.text =self.cityArray[indexPath.row];
    [cell.contentView addSubview:lable];
    return cell;
}

//设置每个分区的区头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 137);
    }
    return CGSizeMake(0, 0);
}
#pragma mark ===========  区头设置
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //区头
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headItem forIndexPath:indexPath];
    _headView.backgroundColor = [UIColor whiteColor];
    //定位城市:显示时
    NSString *city =[[NSUserDefaults standardUserDefaults] valueForKey:@"City"];
    _headView.cityLable.text =[city substringToIndex:city.length - 1];;
     //重新定位方法
    [_headView .reLocationButton addTarget:self action:@selector(reLocation) forControlEvents:UIControlEventTouchUpInside];
    _gelacotion = [[CLGeocoder alloc] init];
    return _headView;

}
- (void)reLocation{
    [ProgressHUD show:@"开始定位…"];
    
    _location = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        FFFLog(@"用户位置服务不可用");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_location requestAlwaysAuthorization];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _location.delegate = self;
        _location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _location.distanceFilter = 10.0;
        [_location startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *lacotion = [locations lastObject];
    CLLocationCoordinate2D coordinate = lacotion.coordinate;
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    [defauls setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lat"];
    [defauls setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    [_gelacotion reverseGeocodeLocation:lacotion completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks firstObject];
        //
        [[NSUserDefaults standardUserDefaults] setValue:placemark.addressDictionary[@"City"] forKey:@"city"];
        //保存
        [defauls synchronize];
    }];
    //如果不需要使用定位服务的时候，请及时关闭定位
    [_location stopUpdatingLocation];
}

- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    
}

//选择效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.cityDelegate && [self.cityDelegate respondsToSelector:@selector(getCityBackName:AndCityId:)]) {
        [self.cityDelegate getCityBackName:self.cityArray[indexPath.row] AndCityId:self.cityIdArray[indexPath.row]];

    
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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
