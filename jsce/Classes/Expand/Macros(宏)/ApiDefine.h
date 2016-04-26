//
//  ApiDefine.h
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#ifndef jsce_ApiDefine_h
#define jsce_ApiDefine_h


//登陆验证接口
#define LOGINCHECKWEB @"http://120.26.40.105:8080/mobile/mobileLoginCheck.html"

//上传修改后的个人信息
#define COMMITUSERINFOWEB @"http://120.26.40.105:8080/mobile/sys/user/updateForMobile.html"

//组织切换接口
#define ORGANIZATIONCHANGEWEB @"http://120.26.40.105:8080/mobile/sys/user/queryUserOrgListNoRepeat.html"

//法律法规-列表接口
#define kLawsAndRegulationsListInterface @"http://192.168.1.13:30003/mobile/laws/lawsInfo"

//法律法规-单条信息接口
#define kLawSingleInfoInterface @"http://192.168.1.13:30003/mobile/laws/lawsInfoContent"

//搜索-法律法规信息接口
#define kLawsInfoTitleSearch @"http://192.168.1.13:30003/mobile/laws/lawsInfoTitleSearch"

//标准规范-列表信息接口
#define kStandSpeoificationInfo @"http://192.168.1.13:30003/mobile/standSpeoification/standSpeoificationInfo"

//搜索标准规范-热门信息接口
#define kStandSpeoificationsTitle @"http://192.168.1.13:30003/mobile/standSpeoification/standSpeoificationsTitle"
#endif
