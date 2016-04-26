//
//  DCLawViewController.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCLawViewController.h"
#import "DSLawCell.h"
#import "DCLawDetailViewController.h"
#import "DCFilterViewController.h"
#import "DiscoverModel.h"
#import "LawContentModel.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface DCLawViewController (){
    NSInteger _total;//总页数
    NSInteger _page;
}
@property(nonatomic,strong)LawsAndRegulationsListModel *larlModel;
@end

@implementation DCLawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"法律法规";
    self.cellType=0;
    self.tableView.loading=YES;
    [self.tableView reloadEmptyDataSetWithTypeStyle:Loading];
    
    [self initData];
    [self configToolBar];
    [self setUpPopView];
    [self configRefresh];
    [self requestData];
}

//初始化数据
- (void)initData{
    self.larlModel = [LawsAndRegulationsListModel shareLawsAndRegulationsList];
    [self.larlModel resetData];
    
    self.toolSoucreArr = @[@[@"关注量 不限",@"关注量 高->低",@"关注量 低->高"],@[@"全部",@"2000年之前",@"2000年~2010年",@"2011年~2012年",@"2013年至今"]];
    
    self.firstColumnArr = @[ @"工程建设国家标准\n(GB)", @"建筑行业标准(JGJ)", @"城建行业标准(CJJ)",@"标准化协会标准\n(CECS)",@"地方标准(DB)", @"强制性条文", @"标准解读"];
    self.secondColumnArr = @[@[@"勘察设计(GB)", @"质量安全(GB)", @"施工技术(GB)", @"工程造价(GB)",
                               @"其他标准(GB)"],
                             @[@"勘察设计(JGJ)", @"质量安全(JGJ)", @"施工技术(JGJ)", @"其他标准(JGJ)"],
                             @[@"道路交通工程", @"桥梁与涵洞工程", @"园林景观工程", @"给水、排水及采暖工程",
                               @"市容与环卫工程", @"城市供气工程", @"城乡规划", @"其他" ],
                             @[ @"工程设计(CECS)", @"质量安全(CECS)", @"施工技术(CECS)",
                                @"其他标准(CECS)"],
                             @[@"北京", @"天津", @"河北", @"辽宁", @"黑龙江", @"河南", @"湖北", @"陕西" ],
                             @[@"建筑/结构设计", @"建筑施工", @"质量验收", @"施工安全", @"抗震及加固",
                               @"建筑节能", @"建筑消防", @"设备安装", @"电气智能", @"工程造价", @"市政工程", @"其他"],
                             @[@"标准解读" ]];
}

//配置刷新
- (void)configRefresh{
    __block typeof(self)weakself= self;
    
    self.tableView.refresh=^{
        [weakself refreshNewData];
    };
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
             [weakself refreshNewData];
    
    }];
    
    // 设置回调
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSomethingWithSelectedCellWithIndex:(NSInteger)index{
    LawContentModel *lawModel = self.dataSouce[index];
    NSURL *url = [NSURL URLWithString:[kLawSingleInfoInterface stringByAppendingString:[NSString stringWithFormat:@"?id=%@",lawModel.lawsId]]];
    
    DCLawDetailViewController *dcldVC = [[DCLawDetailViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:dcldVC animated:YES];
}

#pragma mark MJRefresh
- (void)refreshNewData{
    _page = 1;
    self.larlModel.page = [NSString stringWithFormat:@"%li",_page];

    [self requestData];

}

- (void)loadMoreData{
    if (_page<_total) {
        _page++;
        self.larlModel.page = [NSString stringWithFormat:@"%li",_page];
        [self requestData];
    }else{
        _page = _total;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestData{
    
    [DiscoverModel requsetLawsAndRegulationsListSuccess:^(AFHTTPRequestOperation *operation, id result) {
 
        NSDictionary *dict= result;
        NSDictionary *itemsDict= dict[@"items"];
        _total=[itemsDict[@"total"] integerValue];
        _page = [itemsDict[@"page"] integerValue];
        NSArray *tempArr = [LawContentModel objectArrayWithKeyValuesArray:itemsDict[@"rows"]];
 //判断是否在刷新，避免数据报错
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataSouce removeAllObjects];
            
        }
        [self.dataSouce addObjectsFromArray:tempArr];
        
        [self.tableView reloadData];
        
        if (self.dataSouce.count==0) {
            self.tableView.loading  = NO;
            [self.tableView reloadEmptyDataSetWithTypeStyle:NoData];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        self.tableView.loading  = NO;
        [self.tableView reloadEmptyDataSetWithTypeStyle:NoNetWork];
       
    }];

    
}

- (void)refreshDataWithSelectedIndex:(NSInteger)index WithSection:(NSInteger)section{
    [super refreshDataWithSelectedIndex:index WithSection:section];
    if (section==0) {
        
        self.larlModel.count=[NSString stringWithFormat:@"%li",index];
        [self.tableView.mj_header beginRefreshing];
        
    }else if(section==1){
        NSString *creatStartYears;
        NSString *creatEndYears;
        switch (index) {
            case 0:{
                creatStartYears=@"-1";
                creatEndYears=@"-1";
                 break;
            }
            case 1:{
                creatStartYears=@"-1";
                creatEndYears=@"2000";
                break;
            }
            case 2:{
                creatStartYears=@"2000";
                creatEndYears=@"2010";
                break;
            }
            case 3:{
                creatStartYears=@"2011";
                creatEndYears=@"2012";
                break;
            }
            case 4:{
                creatStartYears=@"2013";
                creatEndYears=@"-1";
                break;
            }
    
            default:
                break;
        }
        
        self.larlModel.creatStartYears=creatStartYears;
        self.larlModel.creatEndYears=creatEndYears;
       [self.tableView.mj_header beginRefreshing];
    }
}

- (void)requestDataWithIndex:(NSInteger)index andIndexPath:(NSIndexPath *)filterIndexPath{
  //  [super requestDataWithIndex:index andIndexPath:filterIndexPath];
    NSString *uStartYears;
    NSString *uEndYears;
    switch (index) {
        case 0:{
            uStartYears=@"2015";
            uEndYears=@"2015";
            break;
        }
        case 1:{
            uStartYears=@"2014";
            uEndYears=@"2014";
            break;
        }
        case 2:{
            uStartYears=@"2013";
            uEndYears=@"2013";
            break;
        }
        case 3:{
            uStartYears=@"-1";
            uEndYears=@"2012";
            break;
        }
            
        default:
            uStartYears=@"-1";
            uEndYears=@"-1";
            break;
    }
    
    self.larlModel.uStartYears=uStartYears;
    self.larlModel.uEndYears  =uEndYears;
    
    if (filterIndexPath.row==-1) {
        self.larlModel.classNameId=@"-1";
        self.larlModel.kindNameId=@"-1";
    }else{
        self.larlModel.classNameId=[NSString stringWithFormat:@"%li",filterIndexPath.section];
        self.larlModel.kindNameId=[NSString stringWithFormat:@"%li",filterIndexPath.row];
    }
    
    [self.tableView.mj_header beginRefreshing];
}
@end
