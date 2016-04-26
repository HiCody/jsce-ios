//
//  MultilevelMenu.m
//  Filter
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MultilevelMenu.h"
#import "FilterFirstColumnCell.h"
#define kCellRightLineTag 100
#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"
#define kMultilevelCollectionHeader   @"CollectionHeader"//CollectionHeader
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MultilevelMenu()
@property(strong,nonatomic ) UITableView * leftTablew;
@property(strong,nonatomic ) UITableView * rightTablew;

@property(assign,nonatomic) BOOL isReturnLastOffset;

@end



@implementation MultilevelMenu
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {

        self.leftSelectColor=[UIColor blackColor];
        self.leftSelectBgColor=[UIColor whiteColor];
        self.leftBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftSeparatorColor=UIColorFromRGB(0xE5E5E5);
        self.leftUnSelectBgColor=UIColorFromRGB(0xF3F4F6);
        self.leftUnSelectColor=[UIColor blackColor];
        
        _selectIndex=0;
        
        /**
         左边的视图
         */
        self.leftTablew=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
        self.leftTablew.dataSource=self;
        self.leftTablew.delegate=self;
        
        self.leftTablew.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTablew];
        self.leftTablew.backgroundColor=self.leftBgColor;
        if ([self.leftTablew respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTablew.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTablew respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTablew.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTablew.separatorColor=self.leftSeparatorColor;
        
        
        /**
         右边的视图
         */
        self.rightTablew=[[UITableView alloc] initWithFrame:CGRectMake(kLeftWidth, 0, kScreenWidth-kLeftWidth, frame.size.height)];
        self.rightTablew.dataSource=self;
        self.rightTablew.delegate=self;
        
        self.rightTablew.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.rightTablew];

        if ([self.rightTablew respondsToSelector:@selector(setLayoutMargins:)]) {
            self.rightTablew.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.rightTablew respondsToSelector:@selector(setSeparatorInset:)]) {
            self.rightTablew.separatorInset=UIEdgeInsetsZero;
        }
        self.rightTablew.separatorColor=self.leftSeparatorColor;
        
        
        self.isReturnLastOffset=YES;
        
        self.rightTablew.backgroundColor=self.leftSelectBgColor;
        
        self.backgroundColor=self.leftSelectBgColor;
       
        self.selectedRightIndex=-1;
        self.lastLeftIndex=-1;
        
    }
    return self;
}

-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
    /**
     *  滑动到 指定行数
     */
    [self.leftTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    _selectIndex=needToScorllerIndex;
    
    [self.rightTablew reloadData];
    
    _needToScorllerIndex=needToScorllerIndex;
}

-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTablew.backgroundColor=leftBgColor;
    
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightTablew.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTablew.separatorColor=leftSeparatorColor;
}
-(void)reloadData{
    
    [self.leftTablew reloadData];
    [self.rightTablew reloadData];
    
}

-(void)setLeftTablewCellSelected:(BOOL)selected withCell:(FilterFirstColumnCell*)cell
{
    UILabel * line=(UILabel*)[cell viewWithTag:kCellRightLineTag];
    if (selected) {
        
        line.backgroundColor=cell.backgroundColor;
        cell.backgroundColor=self.leftSelectBgColor;
    }
    else{
        
        cell.backgroundColor=self.leftUnSelectBgColor;
        line.backgroundColor=_leftTablew.separatorColor;
    }
    
    
}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.leftTablew) {
         return self.firstColumnArr.count;
    }
    NSArray *tempArr =self.secondColumnArr[self.selectIndex];
    return tempArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterFirstColumnCell *cell = (FilterFirstColumnCell *) [self getCellWithTableView:tableView];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    if (tableView == self.leftTablew) {
        NSString *title=self.firstColumnArr[indexPath.row];
        
        cell.title =title;
        
        if (indexPath.row==self.selectIndex) {
      
            [self setLeftTablewCellSelected:YES withCell:cell];
        }
        else{
            [self setLeftTablewCellSelected:NO withCell:cell];
            
        }
        
      
    }else{
   
        NSArray *tempArr  = self.secondColumnArr[self.selectIndex];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0];
        cell.textLabel.text=tempArr[indexPath.row];
        
        if (indexPath.row==self.selectedRightIndex&&self.selectIndex==self.lastLeftIndex) {
            
             cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_selected"]];
        }else{
            cell.accessoryView=UITableViewCellAccessoryNone;
        }
        
    }
      return cell;

}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"cell";
    FilterFirstColumnCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FilterFirstColumnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==self.leftTablew) {
        FilterFirstColumnCell *cell=(FilterFirstColumnCell *)[self getCellWithTableView:tableView];
        cell.title=self.firstColumnArr[indexPath.row];
         return cell.cellHeight;
    }else{
        return 44;
    }

   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTablew) {
     
        FilterFirstColumnCell * cell=(FilterFirstColumnCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        _selectIndex=indexPath.row;
        
        [self setLeftTablewCellSelected:YES withCell:cell];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.isReturnLastOffset=NO;
        
        
        [self.rightTablew reloadData];
        
        [self.rightTablew scrollRectToVisible:CGRectMake(0, 0, self.rightTablew.frame.size.width, self.rightTablew.frame.size.height) animated:self.isRecordLastScrollAnimated];
        
        if (self.selectedRightIndex>=0&&self.selectIndex==self.lastLeftIndex) {
            [self.rightTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRightIndex inSection:self.lastLeftIndex] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
        
    }else{
        self.lastLeftIndex = self.selectIndex;

        FilterFirstColumnCell *cell  =(FilterFirstColumnCell *)[tableView cellForRowAtIndexPath:indexPath];
        self.selectedRightIndex=indexPath.row;
        
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_selected"]];
    }


}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView== self.leftTablew) {
        FilterFirstColumnCell * cell=(FilterFirstColumnCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [self setLeftTablewCellSelected:NO withCell:cell];
        
        cell.backgroundColor=self.leftUnSelectBgColor;
    }else{
        FilterFirstColumnCell *cell  =(FilterFirstColumnCell *)[tableView cellForRowAtIndexPath:indexPath];

        cell.accessoryView=UITableViewCellAccessoryNone;
       
    }

}


@end
