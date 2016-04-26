//
//  DCDownloadTVC.m
//  jsce
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCDownloadTVC.h"

#import "DCDownloadCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2
@implementation DCDownloadTVC

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate=self;
        self.dataSource=self;
        self.bounces=NO;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        [self setUpViews];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    DCDownloadCell *cell =(DCDownloadCell *) [self getCellWithTableView:tableView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.row==0) {
        [cell setTitleStr:self.titleStr andFileSizeStr:nil andIsShow:NO];
    }else if (indexPath.row==1){
       
        [cell setTitleStr:@"文件大小" andFileSizeStr:self.fileSizeStr andIsShow:self.isShow];
    }
    
    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"sCell";
    DCDownloadCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[DCDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCDownloadCell *cell =(DCDownloadCell *) [self getCellWithTableView:tableView];
    if (indexPath.row==0) {
         [cell setTitleStr:self.titleStr andFileSizeStr:nil andIsShow:NO];
        return cell.cellHeight;
    }else{
       [cell setTitleStr:@"文件大小" andFileSizeStr:self.fileSizeStr andIsShow:self.isShow];
        
        return cell.cellHeight;
    }

}    



- (void)setUpViews{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, 60)];
    UILabel *headLable =  [[UILabel alloc] initWithFrame:CGRectMake(18, 0, WinWidth-18, 60)];
    headLable.text=@"下载";
    headLable.textColor=[UIColor blackColor];
    headLable.font = [UIFont systemFontOfSize:17.0];
    headLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:headLable];
    
    UIView *seperateLine=[[UIView alloc] initWithFrame:CGRectMake(0, 59, WinWidth, 1)];
    seperateLine.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1.0];
    [headView addSubview:seperateLine];
    self.tableHeaderView = headView;
    
    
    self.downloadFV=[DCDownloadFootView dcDownloadFootView];
    self.downloadFV.frame=CGRectMake(0, 0, screenWidth, 61);
    self.tableFooterView = self.downloadFV;
    

}



@end
