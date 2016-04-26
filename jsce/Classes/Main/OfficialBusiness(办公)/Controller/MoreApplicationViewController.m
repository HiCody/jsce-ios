//
//  MoreApplicationViewController.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "MoreApplicationViewController.h"
#import "GridItemModel.h"
#import "AddGridView.h"
@interface MoreApplicationViewController ()<AddGridViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)AddGridView *addGridView;
@property (nonatomic,strong)NSMutableArray *deletateArr;
@end

@implementation MoreApplicationViewController
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
    
     self.showBackBtn=YES;
    [self configGridView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加GridView
- (void)configGridView{
    self.addGridView=[[AddGridView alloc] init];
    self.addGridView.frame=self.view.frame;
    self.addGridView.addItemDelegate =self;
    self.addGridView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.addGridView];
    
    [self getDataListFromSand];
    
    self.addGridView.gridModelsArray =self.deletateArr;
}

//获取沙盒内的GridView
-(void)getDataListFromSand{
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

#pragma mark AddGridViewDelegate
- (void)addItemGridViewPassAddValue:(GridItemModel *)model{
    [self.deletateArr removeObject:model];
    [self.dataArray addObject:model];
    [self saveDataListToSand];
}
@end
