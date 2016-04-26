//
//  DiscoverModel.m
//  jsce
//
//  Created by mac on 15/11/9.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DiscoverModel.h"
static id shareLawsAndRegulationsList;
static id shareStandSpeoificationInfo;
@implementation LawsAndRegulationsListModel

+ (instancetype)shareLawsAndRegulationsList
{
    if (shareLawsAndRegulationsList == nil) {
        shareLawsAndRegulationsList = [[LawsAndRegulationsListModel alloc] init];
    }
    
    return shareLawsAndRegulationsList;
}

- (void)resetData{
    self.creatStartYears=@"-1";
    self.creatEndYears=@"-1";
    self.count=@"-1";
    self.uStartYears=@"-1";
    self.uEndYears=@"-1";
    self.classNameId=@"-1";
    self.kindNameId=@"-1";
    self.rows=@"10";
    self.page=@"1";
  
}

@end

@implementation StandSpeoificationInfoModel

+ (instancetype)shareStandSpeoificationInfo
{
    if (shareStandSpeoificationInfo == nil) {
        shareStandSpeoificationInfo = [[StandSpeoificationInfoModel alloc] init];
    }
    
    return shareStandSpeoificationInfo;
}

- (void)resetData{
    self.startCreateYaers=@"-1";
    self.creatEndYears=@"-1";
    self.readingCount=@"-1";
    self.uStartYears=@"-1";
    self.uEndYears=@"-1";
    self.classNameId=@"-1";
    self.kindNameId=@"-1";
    self.downLoadCount=@"-1";
    self.rows=@"6";
    self.page=@"1";
    
}


@end

@implementation DiscoverModel

+ (void)requsetLawsAndRegulationsListSuccess:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure{
    LawsAndRegulationsListModel *larModel = [LawsAndRegulationsListModel shareLawsAndRegulationsList];
    NSDictionary *parameters = @{@"creatStartYears":larModel.creatStartYears,
                                 @"creatEndYears":larModel.creatEndYears,
                                 @"count":larModel.count,
                                 @"uStartYears":larModel.uStartYears,
                                 @"uEndYears":larModel.uEndYears,
                                 @"classNameId":larModel.classNameId,
                                 @"kindNameId":larModel.kindNameId,
                                 @"rows":larModel.rows,
                                 @"page":larModel.page};
    
     [[XBApi SharedXBApi] requestWithURL:kLawsAndRegulationsListInterface paras:parameters type:XBHttpResponseType_Common success:success failure:failure];
}


//法律法规-单条信息接口
+ (void)requsetLawSingleInfoWithID:(NSString *)lawsId Success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure{
    
    NSDictionary *parameters = @{@"id":lawsId};
    
    [[XBApi SharedXBApi] requestWithURL:kLawSingleInfoInterface paras:parameters type:XBHttpResponseType_Common success:success failure:failure];
    
}

+ (void)requestLawsInfoTitleSearchWithTitle:(NSString *)title Success:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure{
    NSDictionary *parameters = @{@"title":title};
    [[XBApi SharedXBApi] requestWithURL:kLawsInfoTitleSearch paras:parameters type:XBHttpResponseType_Common success:success failure:failure];
}

/*-------------------------------------------------------------------------*/
//标准规范-列表信息接口
+ (void)requsetStandSpeoificationInfoSuccess:(void(^)(AFHTTPRequestOperation* operation,id result))success failure:(void(^)(NSError* error))failure{
    StandSpeoificationInfoModel *ssiModel = [StandSpeoificationInfoModel shareStandSpeoificationInfo];
    NSDictionary *parameters = @{@"startCreateYaers":ssiModel.startCreateYaers,
                                 @"creatEndYears":ssiModel.creatEndYears,
                                 @"readingCount":ssiModel.readingCount,
                                 @"uStartYears":ssiModel.uStartYears,
                                 @"uEndYears":ssiModel.uEndYears,
                                 @"classNameId":ssiModel.classNameId,
                                 @"kindNameId":ssiModel.kindNameId,
                                 @"downLoadCount":ssiModel.downLoadCount,
                                 @"rows":ssiModel.rows,
                                 @"page":ssiModel.page};
    
    [[XBApi SharedXBApi] requestWithURL:kStandSpeoificationInfo paras:parameters type:XBHttpResponseType_Common success:success failure:failure];
    
}
@end
