//
//  ReadDetailDBManager.m
//  项目01 9_9
//
//  Created by lanou on 16/9/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "CityDetailDBManager.h"

@implementation CityDetailDBManager

+(instancetype)defaultManager{
    static CityDetailDBManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CityDetailDBManager alloc]init];
    });
    return manager;
}
-(id)init{
    self = [super init];
    if (self) {
        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Project.sqlite"];
        _db = [FMDatabase  databaseWithPath:dbPath];
        NSLog(@"%@",dbPath);
    }
    if (![_db open]) {
        NSLog(@"数据库打开失败");
    }
    return self;
}
-(void)createTable{
    
    [_db open];
    NSString *sqlStr = @"create table if not exists CityDetail ( cityid text,city text,cnty text,lat text,lon text,prov text);";
    BOOL result = [_db executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表成功");
    }
    else{
        NSLog(@"创建表失败");
    }
    [_db close];
}
-(void)insertDataModel:(CityInfoCityInfo *)model{
    
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into CityDetail(cityid,city,cnty,lat,lon,prov)values('%@','%@','%@','%@','%@','%@')",model.cityInfoIdentifier,model.city,model.cnty,model.lat,model.lon,model.prov];
    BOOL result = [_db executeUpdate:sqlStr];
    if (result) {
        NSLog(@"添加成功");
    }
    else{
        NSLog(@"添加失败");
    }
    [_db close];
    
}
-(void)deleteDataWithcityid:(NSString *)cityid{
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"delete from CityDetail where cityid = '%@'",cityid];
    BOOL result = [_db executeUpdate:sqlStr];
    if (result) {
        NSLog(@"删除成功");
    }
    else{
        NSLog(@"删除失败");
    }
    [_db close];
}
-(NSArray<CityInfoCityInfo *> *)selectData{
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from CityDetail"];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *arr = [NSMutableArray array];
    while ([set next]) {
        NSString *cityid = [set objectForColumnName:@"cityid"];
        NSString *city = [set objectForColumnName:@"city"];
        NSString *cnty = [set objectForColumnName:@"cnty"];
        NSString *lat = [set objectForColumnName:@"lat"];
        NSString *lon = [set objectForColumnName:@"lon"];
        NSString *prov = [set objectForColumnName:@"prov"];

        CityInfoCityInfo *model = [CityInfoCityInfo new];
        model.cityInfoIdentifier = cityid;
        model.city = city;
        model.cnty = cnty;
        model.lat = lat;
        model.lon = lon;
        model.prov = prov;
        [arr addObject:model];
    }
    [_db close];
    NSArray *array = [arr copy];
    return array;
}

@end
