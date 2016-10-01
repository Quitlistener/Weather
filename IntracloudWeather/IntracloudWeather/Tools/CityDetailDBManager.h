//
//  ReadDetailDBManager.h
//  项目01 9_9
//
//  Created by lanou on 16/9/21.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "CityInfoDataModels.h"

@interface CityDetailDBManager : NSObject


@property(nonatomic,strong)FMDatabase *db;
+(instancetype)defaultManager;

-(void)createTable;
-(void)insertDataModel:(CityInfoCityInfo *)model;
-(void)deleteDataWithcityid:(NSString *)cityid;
-(NSArray<CityInfoCityInfo *> *)selectData;


@end
