//
//  DiscoverModel.h
//  jsce
//
//  Created by mac on 15/11/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LawsAndRegulationsListModel : NSObject
@property(nonatomic,strong)NSString *creatStartYears;//发布年份(起)
@property(nonatomic,strong)NSString *creatEndYears;//发布年份(末)
@property(nonatomic,strong)NSString *count;//关注量
@property(nonatomic,strong)NSString *uStartYears;//实施年份(起)
@property(nonatomic,strong)NSString *uEndYears;//实施年份(末)
@property(nonatomic,strong)NSString *classNameId;//一级条件
@property(nonatomic,strong)NSString *kindNameId;//二级条件
@property(nonatomic,strong)NSString *rows;//条数
@property(nonatomic,strong)NSString *page;//页数

+ (instancetype)shareLawsAndRegulationsList;

- (void)resetData;
@end

@interface StandSpeoificationInfoModel : NSObject

@property(nonatomic,strong)NSString *startCreateYaers;//发布年份(起)
@property(nonatomic,strong)NSString *creatEndYears;//发布年份(末)
@property(nonatomic,strong)NSString *readingCount;//关注量
@property(nonatomic,strong)NSString *uStartYears;//实施年份(起)
@property(nonatomic,strong)NSString *uEndYears;//实施年份(末)
@property(nonatomic,strong)NSString *classNameId;//一级条件
@property(nonatomic,strong)NSString *kindNameId;//二级条件
@property(nonatomic,strong)NSString *downLoadCount;//下载量
@property(nonatomic,strong)NSString *rows;//条数
@property(nonatomic,strong)NSString *page;//页数

+ (instancetype)shareStandSpeoificationInfo;

- (void)resetData;
@end

@interface DiscoverModel : NSObject

+ (void)requsetLawsAndRegulationsListSuccess:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;

+ (void)requsetStandSpeoificationInfoSuccess:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;

+ (void)requestLawsInfoTitleSearchWithTitle:(NSString *)title Success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure;
@end
