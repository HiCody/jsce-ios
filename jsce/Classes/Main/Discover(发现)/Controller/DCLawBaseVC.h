//
//  DCLawBaseVC.h
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"
#import "DSLawCell.h"
#import "DCLawDetailViewController.h"
#import "DCToolBar.h"
#import "DXPopover.h"
#import "DCFilterViewController.h"
#import "JsceBaseTableView.h"
@interface DCLawBaseVC : JsceBaseVC

@property(nonatomic,strong)JsceBaseTableView *tableView;
@property(nonatomic,strong)JsceBaseTableView *attentionTableView;
@property(nonatomic,strong)JsceBaseTableView *downloadTableView;
@property(nonatomic,strong)JsceBaseTableView *releaseTableView;
@property(nonatomic,strong)NSMutableArray *dataSouce;
@property(nonatomic,strong)DCToolBar *dcToolBar;
@property(nonatomic,strong)NSArray *toolSoucreArr; //保存工具栏里的选项
@property(nonatomic,strong)NSArray *choosedArr;
@property(nonatomic,strong)DXPopover *popView;
@property(nonatomic,strong)NSMutableArray *tvcArr; //保存toolBar上弹出的tableview
@property(nonatomic,strong)NSMutableArray *selectedArr;//保存选中状态;



/**
 *  筛选第一列数据
 */
@property(strong,nonatomic)NSArray *firstColumnArr;


/**
 *  筛选第二列数据
 */
@property(strong,nonatomic)NSArray *secondColumnArr;


@property(nonatomic,assign)NSInteger cellType;
- (void)doSomethingWithSelectedCellWithIndex:(NSInteger)index;

- (void)refreshDataWithSelectedIndex:(NSInteger)index WithSection:(NSInteger)section;

- (void)requestDataWithIndex:(NSInteger)index andIndexPath:(NSIndexPath *)filterIndexPath;

- (void)configToolBar;

- (void)setUpPopView;
@end
