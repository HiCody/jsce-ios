//
//  DCSpecificationViewController.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCSpecificationViewController.h"
#import "DXPopover.h"
#import "DCDownloadTVC.h"
#import "DiscoverModel.h"
#import "StandSpeoificationContent.h"
#define TEXTFONT [UIFont systemFontOfSize:15.0]
@interface DCSpecificationViewController (){
    DXPopover *dxPopView;
    DCDownloadTVC *downloadTableView;
    DCDownloadTVC *downloadTableView2;
    DCDownloadTVC *downloadTableView3;
    UIView *backView;

    NSInteger _total;//总页数
    NSInteger _page;
}
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)StandSpeoificationInfoModel *ssiModel;
@end

@implementation DCSpecificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"标准规范";
    
    self.cellType=1;
    
    self.tableView.loading=YES;
    [self.tableView reloadEmptyDataSetWithTypeStyle:Loading];
    
    [self initData];
    [self configToolBar];
    [self setUpPopView];
    [self configRefresh];
    [self requestData];

    self.titleStr=@"JGJ 106-2014 建筑基桩检测技术规范JGJ建筑基筑基筑基.pdf";

}

- (void)initData{
    self.ssiModel = [StandSpeoificationInfoModel shareStandSpeoificationInfo];
    [self.ssiModel resetData];
    self.toolSoucreArr = @[@[@"关注量 不限",@"关注量 高->低",@"关注量 低->高"],@[@"不限",@"下载量 高->低",@"下载量 低->高"],@[@"全部",@"2000年之前",@"2000年~2010年",@"2011年~2012年",@"2013年至今"]];
    
    self.firstColumnArr = @[@"国家法律", @"建设行政法规", @"国务院文件", @"住建部规章", @"住建部文件",@"相关部委法规文件", @"地方法规文件"];
    self.secondColumnArr = @[@[@"国家法律"],
                             @[@"建设行政法规"],
                             @[@"国务院文件"],
                             @[@"住建部规章"],
                             @[ @"工程质量安全监管", @"标准定额", @"城乡规划", @"住房改革", @"保障与发展",@"城市建设", @"村镇建设", @"建筑节能与科技", @"房地产市场监管", @"建筑市场监管", @"其他文件" ],
                             @[@"相关部委法规文件"],
                             @[@"北京", @"天津", @"河北", @"山西", @"内蒙", @"辽宁",@"吉林", @"黑龙江",@"上海", @"江苏", @"浙江", @"安徽", @"福建", @"江西", @"山东", @"河南", @"湖北", @"湖南",@"广东", @"广西", @"海南", @"重庆", @"四川", @"贵州", @"云南", @"陕西", @"甘肃", @"青海",@"宁夏", @"新疆" ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//配置下载界面
- (void)doSomethingWithSelectedCellWithIndex:(NSInteger)index{
    StandSpeoificationContent *ssc=self.dataSouce[index];
    dxPopView = [DXPopover new];
    dxPopView.arrowSize=CGSizeZero;
    dxPopView.cornerRadius=0;
    dxPopView.isAnimate=YES;
    downloadTableView=[[DCDownloadTVC alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [self getTotalTableViewHeightWithTitle:self.titleStr andIsShow:NO])];
    
    downloadTableView.titleStr = ssc.fileName;
    downloadTableView.fileSizeStr=[NSString stringWithFormat:@"%.2fMB",ssc.fileSize];
    downloadTableView.isShow=NO;
    downloadTableView.downloadFV.btnView.hidden=NO;
    
    [downloadTableView.downloadFV.ensureBtn addTarget:self action:@selector(startDownload:) forControlEvents:UIControlEventTouchUpInside];
    
    [downloadTableView.downloadFV.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    downloadTableView2=[[DCDownloadTVC alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [self getTotalTableViewHeightWithTitle:self.titleStr andIsShow:YES])];
    downloadTableView2.titleStr =  ssc.fileName;
    downloadTableView2.fileSizeStr=[NSString stringWithFormat:@"%.2fMB",ssc.fileSize];
    downloadTableView2.isShow=YES;
    downloadTableView2.downloadFV.cancelDownloadBtn.hidden=NO;
 
    [downloadTableView2.downloadFV.cancelDownloadBtn addTarget:self action:@selector(cancelDownload:) forControlEvents:UIControlEventTouchUpInside];
    
    
    downloadTableView3=[[DCDownloadTVC alloc] initWithFrame:CGRectMake(0, 0, screenWidth, [self getTotalTableViewHeightWithTitle:self.titleStr andIsShow:NO])];
    downloadTableView3.titleStr = ssc.fileName;
    downloadTableView3.fileSizeStr=[NSString stringWithFormat:@"%.2fMB",ssc.fileSize];
    downloadTableView3.isShow=NO;
    downloadTableView3.downloadFV.openFileBtn.hidden=NO;
    
    [downloadTableView3.downloadFV.openFileBtn addTarget:self action:@selector(openFile:) forControlEvents:UIControlEventTouchUpInside];

    CGPoint startPoint = CGPointMake(0, self.view.frame.size.height);
    [dxPopView showAtPoint:startPoint popoverPostion:DXPopoverPositionUp withContentView:downloadTableView inView:self.view];

}

- (void)startDownload:(UIButton *)btn{

    CGPoint startPoint = CGPointMake(0, self.view.frame.size.height);
    
    [dxPopView showAtPoint:startPoint popoverPostion:DXPopoverPositionUp withContentView:downloadTableView2 inView:self.view];

    
}

- (void)cancel:(UIButton *)btn{
    [dxPopView dismiss];
}



- (void)openFile:(UIButton *)btn{
    
}

- (void)cancelDownload:(UIButton *)btn{
    
    CGPoint startPoint = CGPointMake(0, self.view.frame.size.height);
    [dxPopView showAtPoint:startPoint popoverPostion:DXPopoverPositionUp withContentView:downloadTableView3 inView:self.view];
    
}

- (CGFloat)getTotalTableViewHeightWithTitle:(NSString *)title andIsShow:(BOOL)isShow{
    CGFloat paddingX=18;
    CGFloat paddingY=13;
    CGFloat tvHeight=0;
    
    CGSize titleSize=[self sizeWithText:title font:TEXTFONT maxSize:CGSizeMake(screenWidth-2*paddingX, MAXFLOAT)];
    
    tvHeight+= 2*paddingY+titleSize.height;
    
    CGSize fileSize=[self sizeWithText:@"文件大小" font:TEXTFONT maxSize:CGSizeMake(screenWidth-2*paddingX, MAXFLOAT)];

    CGFloat tempheight=paddingY+fileSize.height;
    if (isShow) {
        
        tvHeight+=tempheight+paddingY*2+2+paddingY;
        
    }else{
        tvHeight+=fileSize.height+2*paddingY;
        
    }
    
    tvHeight+=60+61;
    return tvHeight;
}

//配置刷新
- (void)configRefresh{
    __block typeof(self)weakself= self;
    
    self.tableView.refresh=^{
        [weakself refreshNewData];
    };
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself refreshNewData];
        }
        
    }];
    
    // 设置回调
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    
}

#pragma mark MJRefresh
- (void)refreshNewData{
    _page = 1;
    self.ssiModel.page = [NSString stringWithFormat:@"%li",_page];
    [self requestData];
}

- (void)loadMoreData{
    if (_page<_total) {
        _page++;
        self.ssiModel.page = [NSString stringWithFormat:@"%li",_page];
        [self requestData];
    }else{
        _page = _total;
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestData{
    [DiscoverModel  requsetStandSpeoificationInfoSuccess:^(AFHTTPRequestOperation *operation, id result){
        
        NSDictionary *dict= result;
        NSDictionary *itemsDict= dict[@"items"];
        _total=[itemsDict[@"total"] integerValue];
        _page = [itemsDict[@"page"] integerValue];
        NSArray *tempArr = [StandSpeoificationContent objectArrayWithKeyValuesArray:itemsDict[@"rows"]];
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
        
        self.ssiModel.readingCount=[NSString stringWithFormat:@"%li",index];
         [self.tableView.mj_header beginRefreshing];
        
    }else if(section==1){
        
        self.ssiModel.downLoadCount=[NSString stringWithFormat:@"%li",index];
        [self.tableView.mj_header beginRefreshing];
    }else if(section==2){
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
        
        self.ssiModel.startCreateYaers =creatStartYears;
        self.ssiModel.creatEndYears = creatEndYears;
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
    
    self.ssiModel.uStartYears=uStartYears;
    self.ssiModel.uEndYears  =uEndYears;
    
    if (filterIndexPath.row==-1) {
        self.ssiModel.classNameId=@"-1";
        self.ssiModel.kindNameId=@"-1";
    }else{
        self.ssiModel.classNameId=[NSString stringWithFormat:@"%li",filterIndexPath.section];
        self.ssiModel.kindNameId=[NSString stringWithFormat:@"%li",filterIndexPath.row];
    }
    
    [self.tableView.mj_header beginRefreshing];
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
