//
//  ReadDetailDBManager.h
//  项目01 9_9
//
//  Created by lanou on 16/9/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "userInfoModel.h"

@interface userInfoManager : NSObject


@property(nonatomic,strong)FMDatabase *db;
+(instancetype)defaultManager;

-(void)createTable;
-(void)insertDataModel:(userInfoModel *)model;
-(void)deleteDataWithcityid:(NSString *)cityid;
-(void)updateDataWithCityid:(NSString *)cityid newCityid:(NSString *)newCityid;
-(void)updateDataWithVoiceAI:(NSString *)VoiceAI newVoiceAI:(NSString *)newVoiceAI;
-(NSArray<userInfoModel *> *)selectData;


@end