//
//  OfficialBussinessMainVC.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "OfficialBussinessMainVC.h"
#import "GridView.h"
#import "GridItemModel.h"
#import "MoreApplicationViewController.h"
#import "OfficialLeftNaviButton.h"
#import "OptionsViewController.h"
#import "DXPopover.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface OfficialBussinessMainVC ()<GridViewDelegate,UITableViewDataSource,UITableViewDelegate>{
   NSIndexPath *lastIndexPath;
}

@property (nonatomic, strong) GridView *gridView;
@property (nonatomic, strong) NSMutableArray *dataArray;//GriView的内容
@property (nonatomic,strong) NSMutableArray *deletateArr;//保存删除的grid
@property (nonatomic,strong)NSArray *gridListArr;
@property (nonatomic,strong)OfficialLeftNaviButton *leftBtn;
@property (nonatomic,strong)NSMutableArray  *orgdata;
@property(nonatomic , strong)DXPopover *popView;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation OfficialBussinessMainVC
- (NSMutableArray *)orgdata{
    if (!_orgdata) {
        _orgdata = [[NSMutableArray alloc] init];
    }
    return _orgdata;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)deletateArr{
    if (!_deletateArr) {
        
        _deletateArr=[[NSMutableArray alloc] init];
    }
    return _deletateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUIBarButtonItem];
    [self configGridView];
    
    [self setUpPopover];
}

//创建导航栏左右2边按钮
- (void)setUpUIBarButtonItem{
    _leftBtn = [[OfficialLeftNaviButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44) andHeadPortraitStr:@"initial_head_portrait"];
    
    _leftBtn.nameLable.text=[UserInfo shareUserInfo].realName;
    _leftBtn.companyLable.text = [UserInfo shareUserInfo].topOrgName;
    [_leftBtn addTarget:self action:@selector(pushToOrganizationChangedView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:_leftBtn];
    
    
    [self actionCustomRightBtnWithNrlImage:@"official_right" htlImage:nil title:nil action:^{
        //跳转到设置页面
        OptionsViewController *opvc=[[OptionsViewController alloc] init];
        opvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:opvc animated:YES];
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//即将显示的时候刷新GridView
- (void)viewWillAppear:(BOOL)animated{
    
    self.leftBtn.nameLable.text=[UserInfo shareUserInfo].realName;
    
   [self getDataListFromSand];
    
    self.gridView.gridModelsArray = self.dataArray;
}

#pragma mark GrivView部分
//添加GridView
- (void)configGridView{
    self.gridView=[[GridView alloc] init];
    self.gridView.frame=self.view.frame;
    self.gridView.gridViewDelegate =self;
    self.gridView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.gridView];
    
    self.gridListArr =@[@{@"title":@"物料管理",@"imageResString":@"物料管理"},
                        @{@"title":@"安全管理",@"imageResString":@"安全管理"},
                        @{@"title":@"成本管理",@"imageResString":@"成本管理"},
                        @{@"title":@"工程资料管理",@"imageResString":@"工程资料管理"},
                        @{@"title":@"合同管理",@"imageResString":@"合同管理"},
                        @{@"title":@"进度管理",@"imageResString":@"进度管理"},
                        @{@"title":@"劳务分包",@"imageResString":@"劳务分包"},
                        @{@"title":@"设备管理",@"imageResString":@"设备管理"},
                        @{@"title":@"投标管理",@"imageResString":@"投标管理"},
                        @{@"title":@"招标管理",@"imageResString":@"招标管理"},
                        @{@"title":@"质量管理",@"imageResString":@"质量管理"},
                        ];
    [self getDataListFromSand];
    
    if (self.deletateArr.count==0&&self.dataArray.count==0) {
        for (NSDictionary *dict in self.gridListArr) {
            GridItemModel *gim=[GridItemModel gridWithDict:dict];
            [self.dataArray addObject:gim];
        }
    }
    
    self.gridView.gridModelsArray = self.dataArray;
    [self saveDataListToSand];
    

}

//获取沙盒内的GridView
-(void)getDataListFromSand{
    [self.dataArray removeAllObjects];
    [self.deletateArr removeAllObjects];
    NSString *path = [self gridfilePath];
    self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSString *path2 = [self addGridfilePath];
    self.deletateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    
}

//保存现有的GriView
-(void)saveDataListToSand{

    NSString *path = [self gridfilePath];
    [NSKeyedArchiver archiveRootObject:self.dataArray toFile:path];
    
    NSString *path2 = [self addGridfilePath];
    [NSKeyedArchiver archiveRootObject:self.deletateArr toFile:path2];
}

//归档路径
- (NSString *)addGridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AddGrid.plist"];
}

- (NSString *)gridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Grid.plist"];
}


#pragma mark GridViewDelegate
- (void)grideViewPassDeleateValue:(GridItemModel *)model{
    [self.deletateArr addObject:model];
    [self.dataArray removeObject:model];
    [self saveDataListToSand];
}

- (void)grideViewMoveToPassValue:(NSArray *)arr{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:arr];
    [self saveDataListToSand];
}

- (void)grideViewmoreItemButtonClicked:(GridView *)gridView
{
    MoreApplicationViewController *maVC = [[MoreApplicationViewController alloc] init];
    maVC.title = @"更多应用";
   
    [self.navigationController pushViewController:maVC animated:YES];
}

#pragma mark 组织切换部分
- (void)setUpPopover{
    self.popView = [DXPopover new];
    self.popView.arrowSize=CGSizeZero;
    self.popView.cornerRadius=0;
    self.popView.isAnimate = YES;
    
    self.orgdata =[NSMutableArray arrayWithArray:[Organization shareOrganization].organizationArr];
    
    [self getOrgdataAndSetTableView];
}

- (void)getOrgdataAndSetTableView{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate= self;
    self.tableView.dataSource=self;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    self.tableView.frame=CGRectMake(0, 0,W(320), self.orgdata.count*44);
}

//组织切换视图的显示与隐藏
- (void)pushToOrganizationChangedView:(UIButton *)btn{
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//    CGRect rectNav = self.navigationController.navigationBar.frame;
//    CGFloat topHeight=rectStatus.size.height+rectNav.size.height;
    CGPoint startPoint = CGPointMake(0 ,0);
    
    [self.popView showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.tableView inView:self.view];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orgdata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:17];
    
    cell.textLabel.text = self.orgdata[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *lastcell=[tableView cellForRowAtIndexPath:lastIndexPath];
    lastcell.textLabel.font=[UIFont systemFontOfSize:17];
    lastcell.textLabel.textColor = [UIColor blackColor];
    
    self.leftBtn.companyLable.text=self.orgdata[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:18.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:255/255.0 alpha:1.0];
    
#pragma mark 更换公司后请求权限
    [UserInfo shareUserInfo].topOrgName =self.orgdata[indexPath.row];
    [UserInfo shareUserInfo].topOrgId  = [Organization shareOrganization].topOrgIdArr[indexPath.row];
    [UserInfo shareUserInfo].rights = [Organization shareOrganization].rightsArr[indexPath.row];
    
    [self.popView dismiss];
    
    lastIndexPath = indexPath;
}

//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
