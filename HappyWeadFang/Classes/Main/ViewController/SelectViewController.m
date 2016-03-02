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
#import "ProgressHUD.h"

static NSString *headItem = @"HeadIdentifier";
static NSString *itemIdentifier = @"itemIdentifier";

@interface SelectViewController ()<UICollectionViewDataSource,UIBarPositioningDelegate,UICollectionViewDelegateFlowLayout>

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
#pragma mark ----------- 懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        //
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        //设置布局方向为垂直
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
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


#pragma mark *******数据请求
- (void)getCityData{
    AFHTTPSessionManager *cityManager = [AFHTTPSessionManager manager];
    cityManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"数据加载中……"];
    [cityManager GET:kCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        FFFLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        FFFLog(@"%@",responseObject);
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

//补充区头和区尾
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //区头

    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headItem forIndexPath:indexPath];
    _headView.backgroundColor = [UIColor whiteColor];
    return _headView;
    //区尾
}

//
- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    
}

//选择效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    collectionView.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    if (self.cityDelegate && [self.cityDelegate respondsToSelector:@selector(getCityBack:WithCityID:)]) {
        [self.cityDelegate getCityBack:self.cityArray[indexPath.row] WithCityID:self.cityIdArray[indexPath.row]];
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
