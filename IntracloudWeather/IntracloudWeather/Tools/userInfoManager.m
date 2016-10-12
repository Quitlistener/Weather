//
//  ReadDetailDBManager.m
//  项目01 9_9
//
//  Created by lanou on 16/9/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "userInfoManager.h"

@implementation userInfoManager

+(instancetype)defaultManager{
    static userInfoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[userInfoManager alloc]init];
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
    NSString *sqlStr = @"create table if not exists UserInfo(city text,cityid text,inde text,voiceAI text);";
    BOOL result = [_db executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建表成功");
    }
    else{
        NSLog(@"创建表失败");
    }
    [_db close];
}
-(void)insertDataModel:(userInfoModel *)model{
    
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into UserInfo(city,cityid,inde,voiceAI)values('%@','%@','%@','%@')",model.city,model.cityInfoIdentifier,model.index,model.voiceAI];
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
    NSString *sqlStr = [NSString stringWithFormat:@"delete from UserInfo where cityid = '%@'",cityid];
    BOOL result = [_db executeUpdate:sqlStr];
    if (result) {
        NSLog(@"删除成功");
    }
    else{
        NSLog(@"删除失败");
    }
    [_db close];
}
//根据原城市id 修改城市
-(void)updateDataWithNewCity:(NSString *)city newCityid:(NSString *)newCityid newIdenx:(NSString *)newIndex Cityid:(NSString *)cityid {
    [self.db open];
    
    NSString *str = [NSString stringWithFormat:@"update UserInfo set city = '%@',cityid = '%@',inde = '%@' where cityid = '%@'",city,newCityid,newIndex,cityid];
    BOOL result =  [self.db executeUpdate:str];
    
    
    
    if (result) {
        NSLog(@"更新成功");
    }
    else{
        NSLog(@"更新失败");
    }
    [self.db close];
}
//根据原VoiceAI 修改VoiceAI
-(void)updateDataWithCityid:(NSString *)cityid newVoiceAI:(NSString *)newVoiceAI{
    [self.db open];
    BOOL result =  [self.db executeUpdate:@"update UserInfo set voiceAI = '%@' where cityid = '%@'",newVoiceAI,cityid];
    if (result) {
        NSLog(@"更新成功");
    }
    else{
        NSLog(@"更新失败");
    }
    [self.db close];
}
-(NSArray<userInfoModel *> *)selectData{
    [_db open];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from UserInfo"];
    FMResultSet *set = [_db executeQuery:sqlStr];
    NSMutableArray *arr = [NSMutableArray array];
    while ([set next]) {
        NSString *cityid  =  [set objectForColumnName:@"cityid"];
        NSString *voiceAI  = [set objectForColumnName:@"voiceAI"];
        NSString *index = [set objectForColumnName:@"inde"];
        NSString *city = [set objectForColumnName:@"city"];
        userInfoModel *model = [userInfoModel new];
        model.cityInfoIdentifier = cityid;
        model.voiceAI = voiceAI;
        model.city = city;
        model.index = index;
        [arr addObject:model];
    }
    [_db close];
    NSArray *array = [arr copy];
    return array;
}

@end
