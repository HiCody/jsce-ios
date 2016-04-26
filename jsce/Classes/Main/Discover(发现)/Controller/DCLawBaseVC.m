//
//  DCLawBaseVC.m
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//
#import "DCLawBaseVC.h"
#import "DCSpecificationCell.h"
#import "LawContentModel.h"
#import "StandSpeoificationContent.h"
#import "DCInquiryViewController.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@interface DCLawBaseVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,DCToolBarDelegate>{
    NSInteger choosedIndex;
    CGFloat topHeight;
}

@end

@implementation DCLawBaseVC
- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [[NSMutableArray alloc] init];
    }
    return _selectedArr;
}

- (NSMutableArray *)tvcArr{
    if (!_tvcArr) {
        _tvcArr = [[NSMutableArray alloc] init];
    }
    return _tvcArr;
}
- (NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce  =[[NSMutableArray alloc] init];
    }
    return _dataSouce;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showBackBtn=YES;
    
    NSIndexPath *indexePath =[NSIndexPath indexPathForRow:0 inSection:5];
    self.selectedArr =[@[indexePath,indexePath,indexePath] mutableCopy];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    topHeight=rectStatus.size.height+rectNav.size.height;
    
    [self configNaviRightButton];
    
    [self configTableView];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNaviRightButton{
    [self actionCustomRightBtnWithNrlImage:nil htlImage:nil title:@"查询" action:^{
        DCInquiryViewController *inquireyVC=[[DCInquiryViewController alloc] init];
        [self presentViewController:inquireyVC animated:YES completion:nil];
    }];
}


//添加底部工具栏
- (void)configToolBar{
    
    self.dcToolBar = [[DCToolBar alloc] init];
    self.dcToolBar.frame = CGRectMake(0, self.view.frame.size.height-topHeight-60, screenWidth, 60);
    self.dcToolBar.backgroundColor=[UIColor hexFloatColor:@"525260"];
    self.dcToolBar.delegate = self;
    [self.dcToolBar addTabButtonWithImgName:@"find_conditions1" andImaSelName:@"find_conditions2" andTitle:@"筛选"];
    [self.dcToolBar addTabButtonWithImgName:@"find_foucs1" andImaSelName:@"find_foucs2" andTitle:@"关注量"];
    
    if (self.toolSoucreArr.count==3) {
        [self.dcToolBar addTabButtonWithImgName:@"find_downloads1" andImaSelName:@"find_downloads2" andTitle:@"下载量"];
    }
    
    [self.dcToolBar addTabButtonWithImgName:@"find_date1" andImaSelName:@"find_date2" andTitle:@"发布日期"];

    [self.view addSubview:self.dcToolBar];
  
}

- (void)willSelectIndex:(NSInteger)selIndex{
    if (selIndex!=0) {
        choosedIndex  = selIndex-1;
    }
    if (selIndex==0) {
#pragma  mark 跳转筛选界面
        DCFilterViewController *dcfVC = [[DCFilterViewController alloc] init];
        dcfVC.firstColumnArr = self.firstColumnArr;
        dcfVC.secondColumnArr = self.secondColumnArr;
        __block typeof(self)weakself =  self;
        dcfVC.refreshByFilter=^(NSInteger index,NSIndexPath *filterIndexPath){
            [weakself requestDataWithIndex:index andIndexPath:filterIndexPath];
        };
        
        [self.navigationController pushViewController:dcfVC animated:YES];
        
    }else {
 //弹出选相
        CGPoint startPoint = CGPointMake(0, self.view.frame.size.height);
        self.choosedArr =self.toolSoucreArr[choosedIndex];
        
        UITableView *tableView1 = self.tvcArr[choosedIndex];
        
        tableView1.frame=CGRectMake(0, 0,WinWidth, self.choosedArr.count*55);
        [self.popView showAtPoint:startPoint popoverPostion:DXPopoverPositionUp withContentView:tableView1 inView:self.view];
    }
}

//设置PopView
- (void)setUpPopView{
    self.popView = [DXPopover new];
    self.popView.arrowSize=CGSizeZero;
    self.popView.cornerRadius=0;
    self.popView.isAnimate=YES;
    
    self.releaseTableView = [[JsceBaseTableView alloc] init];
    self.releaseTableView.delegate= self;
    self.releaseTableView.dataSource=self;
    
    self.downloadTableView = [[JsceBaseTableView alloc] init];
    self.downloadTableView.delegate= self;
    self.downloadTableView.dataSource=self;
    
    self.attentionTableView = [[JsceBaseTableView alloc] init];
    self.attentionTableView.delegate= self;
    self.attentionTableView.dataSource=self;
    
    
    [self.tvcArr  addObject:self.attentionTableView];
    if (self.toolSoucreArr.count==3) {
        [self.tvcArr addObject:self.downloadTableView];
    }
 
    [self.tvcArr addObject:self.releaseTableView];
    
}

- (void)configTableView{
    
    self.tableView= [[JsceBaseTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-topHeight) style:UITableViewStylePlain];
    
    self.tableView.dataSource=self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView ==self.tableView) {
        return self.dataSouce.count;
    }
    
    return self.choosedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.tableView) {
        
        static NSString *identifier = @"cell";
        if (self.cellType==0) {
            DSLawCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [DSLawCell cell];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LawContentModel *lawContent = self.dataSouce[indexPath.row];
            cell.titileLable.text = lawContent.title;
            cell.detailLable.text = lawContent.shortInfo;
            cell.cityLable.text = lawContent.areaName;
            cell.checkCountLable.text=[NSString stringWithFormat:@"%li",lawContent.readingCount];
            cell.releaseDateLable.text = lawContent.createTime;
            
            if (lawContent.firstId>=0&&lawContent.firstId<=6) {
                 cell.imgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"law_pic%li",lawContent.firstId]];
            }else{
                 cell.imgView.image=[UIImage imageNamed:@"law_pic0"];
            }
           
            
            return cell;
        }else{
            
            DCSpecificationCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [DCSpecificationCell cell];
            }
            StandSpeoificationContent *ssc = self.dataSouce[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.titleLable.text=ssc.title;
            cell.checkCountLable.text= [NSString stringWithFormat:@"%li",ssc.readingCount];
            cell.releaseTimeLable.text=ssc.createTime;
            cell.fileLable.text=[NSString stringWithFormat:@"%.2fMB",ssc.fileSize];
            
            return cell;
        }
        
        
    }else{
        static NSString *identifier = @"cell2";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UILabel *lable = [[UILabel alloc] init];
        lable.frame =CGRectMake(0, 0, WinWidth, 55);
        lable.font = [UIFont systemFontOfSize:16.0];
        lable.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lable.text = self.choosedArr[indexPath.row];
        
        
        [cell.contentView addSubview:lable];
        return cell;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView  == self.tableView) {
        if (self.cellType==0) {
            return 100;
        }else{
            return 70;
        }
        
    }else{
        return 55;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView  == self.tableView) {
        
        [self doSomethingWithSelectedCellWithIndex:indexPath.row];
        
    }else{
        
        NSIndexPath *lastIndexPath  = self.selectedArr[choosedIndex];
        
        if (lastIndexPath.section!=5) {
            UITableViewCell *lastCell  = [tableView cellForRowAtIndexPath:lastIndexPath];
            lastCell.accessoryView=[[UIView alloc] initWithFrame:CGRectZero];;
        }
        
        UITableViewCell *cell  =[tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_selected"]];
        
        lastIndexPath = indexPath;
        
        
        UILabel *lable=cell.contentView.subviews[0];
        [self.dcToolBar.selectBtn  setTitle:lable.text forState:UIControlStateNormal];
        
        [self.selectedArr replaceObjectAtIndex:choosedIndex withObject:indexPath];
        
      
         
        [self refreshDataWithSelectedIndex:indexPath.row WithSection:choosedIndex];
            

        
        [self.popView dismiss];
    }
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

- (void)doSomethingWithSelectedCellWithIndex:(NSInteger)index{
    
}

- (void)refreshDataWithSelectedIndex:(NSInteger)index WithSection:(NSInteger)section{
    
}

- (void)requestDataWithIndex:(NSInteger)index andIndexPath:(NSIndexPath *)filterIndexPath{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.dcToolBar.hidden=YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.dcToolBar.hidden=NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.dcToolBar.hidden=NO;
}
@end
