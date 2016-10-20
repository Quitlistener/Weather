//
//  RightMenViewController.m
//  IntracloudWeather
//
//  Created by lanou on 2016/9/28.
//  Copyright © 2016年 guangjia. All rights reserved.
//

#import "RightMenViewController.h"
#import "AddCitysCollectionViewCell.h"
#import "HotCityViewController.h"
#import "CityDetailDBManager.h"
#import "CityInfoDataModels.h"
#import "AddCollectionViewCell.h"
#import "NetWorkRequest.h"
#import "WeatherDataModels.h"
#import "UIImageView+WebCache.h"
#import "userInfoModel.h"
#import "UIViewController+MMDrawerController.h"
#import "WeatherViewController.h"
#import "Monitor.h"
#import "AppDelegate.h"

@interface RightMenViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,reloadData>

{
    NSMutableArray *_citysDataArr;
    UICollectionView *_CityCollectionView;
    BOOL isEdit;
    UIBarButtonItem *_editItem;
    WeatherBaseClass *_BaseModels;
    BOOL isnotFirst;
}
@property(nonatomic,strong)NSMutableArray *todayArrs;

@end

@implementation RightMenViewController

-(void)reloadData{
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    CityInfoCityInfo *city = _citysDataArr.lastObject;
    [_todayArrs removeAllObjects];
    for (int i = 0; i < _citysDataArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [_todayArrs addObject:str];
    }
    [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (isnotFirst) {
        NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
        _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
        CityInfoCityInfo *city = _citysDataArr.lastObject;
        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:nil];
        //        isnotFirst = YES;
        //        [_CityCollectionView reloadData];
    }
    else{
        //        NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
        //        _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
        //        CityInfoCityInfo *city = _citysDataArr.lastObject;
        //        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:nil];
        [_CityCollectionView reloadData];
        isnotFirst = YES;
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    if (isEdit == 1) {
        [self editCitys];
    }
    else{
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *mydelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mydelegate.delegate_reload = self;
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    _todayArrs = [NSMutableArray array];
    for (int i = 0; i < _citysDataArr.count; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [_todayArrs addObject:str];
    }
    [self reloadCitys];
    [self initUI];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backItem)];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    //    self.navigationItem.backBarButtonItem = backItem;
    //    backItem.title = @"返回";
    
    // Do any additional setup after loading the view.
    //    [self viewWillAppear:YES];
}
-(void)initUI{
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backWeatherController)];
    UIImage *image = [[UIImage imageNamed:@"返回.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backWeatherController)];
    self.navigationItem.title = @"城市管理";
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadCitys)];
    _editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCitys)];
    self.navigationItem.rightBarButtonItems = @[reloadItem,_editItem];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 7.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 10);
    flowLayout.itemSize = CGSizeMake(83, 115);
    
    UICollectionView *CityCollectionVew = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 279, SCREENH_height) collectionViewLayout:flowLayout];
    CityCollectionVew.backgroundColor =  [UIColor whiteColor];
    CityCollectionVew.delegate = self;
    CityCollectionVew.dataSource = self;
    [CityCollectionVew registerNib:[UINib nibWithNibName:@"AddCitysCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"City"];
    [CityCollectionVew registerNib:[UINib nibWithNibName:@"AddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Add"];
    
    //    //注册尾视图
    [CityCollectionVew registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"City"];
    _CityCollectionView = CityCollectionVew;
    [self.view addSubview:CityCollectionVew];
}
//返回头部和尾部的样式
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //需要判断返回头部视图还是尾部视图
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"City" forIndexPath:indexPath];
        //        UIView *view = [[UIView alloc]init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesInside)];
        tapGes.numberOfTapsRequired = 1;
        tapGes.numberOfTouchesRequired = 1;
        [footView addGestureRecognizer:tapGes];
        //        [footView addSubview:view];
        return footView;
    }
    else{
        //初始化头部视图
        
        return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (_citysDataArr.count < 4) {
        return CGSizeMake(SCREEN_width, SCREENH_height - 130);
    }
    else if (_citysDataArr.count < 7){
        return CGSizeMake(SCREEN_width, SCREENH_height - 262);
    }
    else{
        return CGSizeMake(SCREEN_width, SCREENH_height - 384);
    }
}
-(void)touchesInside{
    if (isEdit == 1) {
        [self editCitys];
    }
    else{
        
    }
}


-(void)backWeatherController{
    //    WeatherViewController *WVC = [WeatherViewController new];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}
#pragma -mark 网络请求
-(void)dataRequestWithCityid:(NSString *)cityid indexPath:(NSIndexPath *)indexPath{
    [Monitor monitorWithView:self.view];
    //    NSString *str = [NSString stringWithFormat:@"key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",cityid];
    //    NSString *urlStr = [@"https://api.heweather.com/x3/weather?" stringByAppendingString:str];
    NSString *urlStr = [NSString stringWithFormat:@"http://apis.baidu.com/heweather/weather/free?cityid=%@",cityid];
    [NetWorkRequest requestWithMethod:GET URL:urlStr para:nil success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dic_____%@",dic);
        if (dic[@"HeWeather data service 3.0"]) {
            _BaseModels = [WeatherBaseClass modelObjectWithDictionary:dic];
            WeatherHeWeatherDataService30 *HeWeatherDataService30 = [_BaseModels heWeatherDataService30].firstObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isnotFirst) {
                    if (HeWeatherDataService30.dailyForecast.count > 0) {
                        WeatherDailyForecast *today = [HeWeatherDataService30 dailyForecast].firstObject;
                        [_todayArrs addObject:today];
                    }
                    [_CityCollectionView reloadData];
                }
                else{
                    for (int i = 0; i < _citysDataArr.count; i++) {
                        CityInfoCityInfo *cityinfo = _citysDataArr[i];
                        if ([cityinfo.cityInfoIdentifier isEqualToString:cityid]) {
                            if (HeWeatherDataService30.dailyForecast.count > 0) {
                                WeatherDailyForecast *today = [HeWeatherDataService30 dailyForecast].firstObject;
                                [_todayArrs replaceObjectAtIndex:i withObject:today];
                            }
                        }
                    }
                }
            });
        }
    } error:^(NSError *error) {
        //        NSLog(@"error____%@",[error description]);
    }];
    
    
}
//-(void)dataRequestWithCityid:(NSString *)cityid indexPath:(NSIndexPath *)indexPath{
//
//    NSString *str = [NSString stringWithFormat:@"key=2e39142365f74cba8c3d9ccc09f73eaa&cityid=%@",cityid];
//    NSString *urlStr = [@"https://api.heweather.com/x3/weather?" stringByAppendingString:str];
//
//    [NetWorkRequest requestWithMethod:GET URL:urlStr para:nil success:^(NSData *data) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
////        NSLog(@"dic_____%@",dic);
//        if (dic[@"HeWeather data service 3.0"]) {
//            _BaseModels = [WeatherBaseClass modelObjectWithDictionary:dic];
//            WeatherHeWeatherDataService30 *HeWeatherDataService30 = [_BaseModels heWeatherDataService30].firstObject;
//            WeatherDailyForecast *today = [HeWeatherDataService30 dailyForecast].firstObject;
//            WeatherCond *cond = [today cond];
//            WeatherTmp *tmp = [today tmp];
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                AddCitysCollectionViewCell *cell = ( AddCitysCollectionViewCell *)[_CityCollectionVew cellForItemAtIndexPath:indexPath];
//                cell.XYTopTempLabel.text = [tmp.max stringByAppendingString:@"℃"];
//                cell.XYDownTempLabel.text = [tmp.min stringByAppendingString:@"℃"];
//                if ([[cond txtD] isEqualToString:[cond txtN]]) {
//                    cell.XYWeatherConLabel.text = [cond txtD];
//                }
//                else{
//                    cell.XYWeatherConLabel.text = [[cond txtD] stringByAppendingFormat:@"转%@",[cond txtN]];
//                }
//                NSString *urlStr = [NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",cond.codeD];
//                [cell.XYConditionImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//
//            });
//        }
//    } error:^(NSError *error) {
//        //        NSLog(@"error____%@",[error description]);
//    }];
//
//
//}

//管理城市 删除操作
-(void)editCitys{
    
    if (isEdit == 0) {
        
        isEdit = 1;
        _editItem.title = @"完成";
        
        //        循环遍历整个CollectionView；
        for(id cell in _CityCollectionView.visibleCells){
            
            NSIndexPath *indexPath = [_CityCollectionView indexPathForCell:cell];
            //除最后一个cell外都显示删除按钮；
            
            if (_citysDataArr.count < 9 && indexPath.row != _citysDataArr.count){
                AddCitysCollectionViewCell *cell2  =  (AddCitysCollectionViewCell *)cell;
                cell2.XYDelectBtn.hidden = 0;
                [UIView animateWithDuration:0.1 delay:0 options:0  animations:^
                 {
                     //顺时针旋转0.05 = 0.05 * 180 = 9°
                     cell2.transform=CGAffineTransformMakeRotation(-0.02);
                 } completion:^(BOOL finished)
                 {
                     //  重复                                  反向            动画时接收交互
                     /**
                      UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
                      UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
                      UIViewAnimationOptionRepeat                    //动画重复执行
                      UIViewAnimationOptionAutoreverse               //来回运行动画
                      UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
                      UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
                      UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
                      UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
                      UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
                      */
                     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                      {
                          cell2.transform=CGAffineTransformMakeRotation(0.02);
                      } completion:^(BOOL finished) {}];
                 }];
            }
            if (_citysDataArr.count == 9 && indexPath.row == 8 ) {
                AddCitysCollectionViewCell *cell2  =  (AddCitysCollectionViewCell *)cell;
                cell2.XYDelectBtn.hidden = 0;
                [UIView animateWithDuration:0.1 delay:0 options:0  animations:^
                 {
                     //顺时针旋转0.05 = 0.05 * 180 = 9°
                     cell2.transform=CGAffineTransformMakeRotation(-0.02);
                 } completion:^(BOOL finished)
                 {
                     //  重复                                  反向            动画时接收交互
                     /**
                      UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
                      UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
                      UIViewAnimationOptionRepeat                    //动画重复执行
                      UIViewAnimationOptionAutoreverse               //来回运行动画
                      UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
                      UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
                      UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
                      UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
                      UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
                      */
                     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                      {
                          cell2.transform=CGAffineTransformMakeRotation(0.02);
                      } completion:^(BOOL finished) {}];
                 }];
                
            }
            if (indexPath.row == _citysDataArr.count){
                AddCollectionViewCell *cell2 = (AddCollectionViewCell * )cell;
                cell2.hidden = 1;
            }
            
        }
        
        
    }
    else if (isEdit == 1){
        isEdit = 0;
        _editItem.title = @"编辑";
        
    }
    [_CityCollectionView reloadData];
    
}

////开始抖动
//
//- (void)starLongPress:(AddCitysCollectionViewCell*)cell{
//
//    CABasicAnimation *animation = (CABasicAnimation *)[cell.layer animationForKey:@"rotation"];
//
//    if (animation == nil) {
//
//        [self shakeImage:cell];
//
//    }else {
//
//        [self resume:cell];
//
//    }
//
//}
//
////这个参数的理解比较复杂，我的理解是所在layer的时间与父layer的时间的相对速度，为1时两者速度一样，为2那么父layer过了一秒，而所在layer过了两秒（进行两秒动画）,为0则静止。
//
//- (void)pause:(AddCitysCollectionViewCell*)cell {
//
//    cell.layer.speed = 0.0;
//
//}
//
//- (void)resume:(AddCitysCollectionViewCell*)cell {
//
//    cell.layer.speed = 1.0;
//
//}
//
//- (void)shakeImage:(AddCitysCollectionViewCell*)cell {
//
//    //创建动画对象,绕Z轴旋转
//
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//    //设置属性，周期时长
//
//    [animation setDuration:0.08];
//
//    //抖动角度
//
//    animation.fromValue = @(-M_1_PI/2);
//
//    animation.toValue = @(M_1_PI/2);
//
//    //重复次数，无限大
//
//    animation.repeatCount = HUGE_VAL;
//
//    //恢复原样
//
//    animation.autoreverses = YES;
//
//    //锚点设置为图片中心，绕中心抖动
//
//    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
//
//    [cell.layer addAnimation:animation forKey:@"rotation"];
//
//}



-(void)longGesture:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateBegan) {
        [self editCitys];
    }
    else{
        
    }
}
- (void)deleteCellButtonPressed: (id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%ld",btn.tag);
    //删除cell；
    if ([[CityDetailDBManager defaultManager] selectData].count > 1) {
        CityInfoCityInfo *city = _citysDataArr[btn.tag - 10];
        [[CityDetailDBManager defaultManager] deleteDataWithcityid:city.cityInfoIdentifier];
        [_citysDataArr removeObjectAtIndex:btn.tag - 10];
        [_todayArrs removeObjectAtIndex:btn.tag - 10];
        userInfoModel *model = [[CityDetailDBManager defaultManager]selectCityData].firstObject;
        if ([model.cityInfoIdentifier isEqualToString:city.cityInfoIdentifier]) {
            CityInfoCityInfo *city2 = _citysDataArr.firstObject;
            [[CityDetailDBManager defaultManager]updateDataWithNewCity:city2.city newCityid:city2.cityInfoIdentifier newIdenx:0 Cityid:model.cityInfoIdentifier];
        }
        
        [_CityCollectionView reloadData];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请至少保留一个城市"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [alertView show];
        //            sleep(1.5);
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        return;
    }
    
}

//刷新管理的城市数据
-(void)reloadCitys{
    
    NSArray *dataArr = [[CityDetailDBManager defaultManager] selectData];
    _citysDataArr = [[NSMutableArray alloc]initWithArray:dataArr];
    [_CityCollectionView reloadData];
    for (int i = 0; i < _citysDataArr.count; i++) {
        CityInfoCityInfo *city = _citysDataArr[i] ;
        [self dataRequestWithCityid:city.cityInfoIdentifier indexPath:nil];
    }
    [_CityCollectionView reloadData];
    
}

#pragma -mark collection协议方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_citysDataArr.count == 9) {
        return 9;
    }
    return _citysDataArr.count + 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_citysDataArr.count < 9 && indexPath.item != _citysDataArr.count) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        cell.XYCityLabel.text = city.city;
        cell.XYCityLabel.layer.cornerRadius = 5;
        cell.XYCityLabel.layer.masksToBounds = YES;
        if ( [_todayArrs[indexPath.row] isKindOfClass:[WeatherDailyForecast class]]){
            WeatherDailyForecast *today = _todayArrs[indexPath.row];
            WeatherCond *cond = [today cond];
            WeatherTmp *tmp = [today tmp];
            cell.XYTopTempLabel.text = [tmp.max stringByAppendingString:@"℃"];
            cell.XYDownTempLabel.text = [tmp.min stringByAppendingString:@"℃"];
            //            NSLog(@"'%@",[cond txtD]);
            if ([[cond txtD] isEqualToString:[cond txtN]]) {
                cell.XYWeatherConLabel.text = [cond txtD];
            }
            else{
                cell.XYWeatherConLabel.text = [[cond txtD] stringByAppendingFormat:@"转%@",[cond txtN]];
            }
            NSString *urlStr = [NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",cond.codeD];
            [cell.XYConditionImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        }
        
        //创建长按手势对象
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
        [cell addGestureRecognizer:longGesture];
        //设置删除按钮
        // 点击编辑按钮触发事件
        if(isEdit == 0){
            //正常情况下，所有删除按钮都隐藏；
            cell.XYDelectBtn.hidden = true;
        }else{
            cell.XYDelectBtn.hidden = 0;
            [UIView animateWithDuration:0.1 delay:0 options:0  animations:^
             {
                 //顺时针旋转0.05 = 0.05 * 180 = 9°
                 cell.transform=CGAffineTransformMakeRotation(-0.02);
             } completion:^(BOOL finished)
             {
                 //  重复                                  反向            动画时接收交互
                 /**
                  UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
                  UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
                  UIViewAnimationOptionRepeat                    //动画重复执行
                  UIViewAnimationOptionAutoreverse               //来回运行动画
                  UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
                  UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
                  UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
                  UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
                  UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
                  */
                 [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                  {
                      cell.transform=CGAffineTransformMakeRotation(0.02);
                  } completion:^(BOOL finished) {}];
             }];
            
        }
        [cell.XYDelectBtn addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.XYDelectBtn.tag = indexPath.row + 10;
        return cell;
        
    }
    if (_citysDataArr.count == 9 ) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        AddCitysCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"City" forIndexPath:indexPath];
        cell.XYCityLabel.text = city.city;
        cell.XYCityLabel.layer.cornerRadius = 5;
        cell.XYCityLabel.layer.masksToBounds = YES;
        if (_todayArrs.count > 0) {
            WeatherDailyForecast *today = _todayArrs[indexPath.row];
            WeatherCond *cond = [today cond];
            WeatherTmp *tmp = [today tmp];
            cell.XYTopTempLabel.text = [tmp.max stringByAppendingString:@"℃"];
            cell.XYDownTempLabel.text = [tmp.min stringByAppendingString:@"℃"];
            if ([[cond txtD] isEqualToString:[cond txtN]]) {
                cell.XYWeatherConLabel.text = [cond txtD];
            }
            else{
                cell.XYWeatherConLabel.text = [[cond txtD] stringByAppendingFormat:@"转%@",[cond txtN]];
            }
            NSString *urlStr = [NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",cond.codeD];
            [cell.XYConditionImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        }
        
        //创建长按手势对象
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
        [cell addGestureRecognizer:longGesture];
        //设置删除按钮
        // 点击编辑按钮触发事件
        if(isEdit == 0){
            //正常情况下，所有删除按钮都隐藏；
            cell.XYDelectBtn.hidden = true;
        }else{
            //可删除情况下；
            //cell数组中的最后一个是添加按钮，不能删除；
            cell.XYDelectBtn.hidden = false;
            [UIView animateWithDuration:0.1 delay:0 options:0  animations:^
             {
                 //顺时针旋转0.05 = 0.05 * 180 = 9°
                 cell.transform=CGAffineTransformMakeRotation(-0.02);
             } completion:^(BOOL finished)
             {
                 //  重复                                  反向            动画时接收交互
                 /**
                  UIViewAnimationOptionAllowUserInteraction      //动画过程中可交互
                  UIViewAnimationOptionBeginFromCurrentState     //从当前值开始动画
                  UIViewAnimationOptionRepeat                    //动画重复执行
                  UIViewAnimationOptionAutoreverse               //来回运行动画
                  UIViewAnimationOptionOverrideInheritedDuration //忽略嵌套的持续时间
                  UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
                  UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
                  UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
                  UIViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
                  */
                 [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                  {
                      cell.transform=CGAffineTransformMakeRotation(0.02);
                  } completion:^(BOOL finished) {}];
             }];
            
        }
        [cell.XYDelectBtn addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.XYDelectBtn.tag = indexPath.row + 10;
        return cell;
        
    }
    
    AddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Add" forIndexPath:indexPath];
    if (isEdit == 0) {
        cell.hidden = 0;
    }
    else{
        cell.hidden = 1;
    }
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_citysDataArr.count < 9 && indexPath.item != _citysDataArr.count) {
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        [[CityDetailDBManager defaultManager] createCityTable];
        NSArray *arr = [[CityDetailDBManager defaultManager] selectCityData];
        userInfoModel *infoModel = arr.firstObject;
        NSMutableString *voiceAI = [NSMutableString stringWithString:@"xiaoyan"];
        if (infoModel.voiceAI) {
            voiceAI = [infoModel.voiceAI copy];
            [[CityDetailDBManager defaultManager] deleteCityDataWithcityid:[arr.firstObject cityInfoIdentifier]];
        }
        userInfoModel *model = [userInfoModel new];
        model.voiceAI = [voiceAI copy];
        model.index = [NSString stringWithFormat:@"%ld",indexPath.row];
        model.city = city.city;
        model.cityInfoIdentifier = city.cityInfoIdentifier;
        [[CityDetailDBManager defaultManager] insertCityDataModel:model];
        WeatherViewController *WVC = [WeatherViewController new];
        [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
        
    }
    else if (_citysDataArr.count == 9){
        
        CityInfoCityInfo *city = _citysDataArr[indexPath.row];
        [[CityDetailDBManager defaultManager] createCityTable];
        NSArray *arr = [[CityDetailDBManager defaultManager] selectCityData];
        userInfoModel *infoModel = arr.firstObject;
        NSMutableString *voiceAI = [NSMutableString stringWithString:@"xiaoyan"];
        if (infoModel.voiceAI) {
            voiceAI = [infoModel.voiceAI copy];
            [[CityDetailDBManager defaultManager] deleteCityDataWithcityid:[arr.firstObject cityInfoIdentifier]];
        }
        userInfoModel *model = [userInfoModel new];
        model.voiceAI = [voiceAI copy];
        model.index = [NSString stringWithFormat:@"%ld",indexPath.row];
        model.city = city.city;
        model.cityInfoIdentifier = city.cityInfoIdentifier;
        [[CityDetailDBManager defaultManager] insertCityDataModel:model];
        WeatherViewController *WVC = [WeatherViewController new];
        [self.mm_drawerController setCenterViewController:WVC withCloseAnimation:YES completion:nil];
        
    }
    else{
        
        HotCityViewController *HCVC = [HotCityViewController new];
        [self.navigationController pushViewController:HCVC animated:YES];
        
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
