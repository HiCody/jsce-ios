//
//  MMAgencyMattersViewController.m
//  jsce
//
//  Created by mac on 15/9/25.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMAgencyMattersViewController.h"
#import "HMSegmentedControl.h"
#import "BaseNoDataView.h"
@interface MMAgencyMattersViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic,strong)UITableView *untreatedTableView;
@property (nonatomic,strong)UITableView *treatedTableView;
@property (nonatomic,strong)NSMutableArray *untreatedArr;
@property (nonatomic,strong)NSMutableArray *treatedArr;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)BaseNoDataView *baseNdView;
@property (nonatomic,strong)BaseNoDataView *baseNdView2;
@end

@implementation MMAgencyMattersViewController
- (NSMutableArray *)untreatedArr{
    if (!_untreatedArr) {
        _untreatedArr =[[NSMutableArray alloc] init];
    }
    return _untreatedArr;
}

- (NSMutableArray *)treatedArr{
    if (!_treatedArr) {
        _treatedArr = [[NSMutableArray alloc] init];
    }
    return _treatedArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代办事项";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.untreatedArr=[@[@"",@""] mutableCopy];
    
    self.showBackBtn=YES;
    [self setUpTableView];
    
    [self setUpSegmentedControl];
    
    [self setUpRightBtn];
}

- (void)setUpRightBtn{
    
    self.rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [ self.rightBtn setTitle:@"清空" forState:UIControlStateNormal];
    [ self.rightBtn addTarget:self action:@selector(clearAllContent) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn.hidden=YES;
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithCustomView: self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}


//已处理内内容全部移除
- (void)clearAllContent{
    [self.treatedArr removeAllObjects];
    [self.treatedTableView reloadData];
}

- (void)setUpTableView{
    self.untreatedTableView=[[UITableView alloc] init];
    self.untreatedTableView.delegate = self;
    self.untreatedTableView.dataSource = self;
    self.untreatedTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    if ([self.untreatedTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.untreatedTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.untreatedTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.untreatedTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    self.treatedTableView = [[UITableView alloc] init];
    self.treatedTableView.delegate = self;
    self.treatedTableView.dataSource = self;
    self.treatedTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    if ([self.treatedTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.treatedTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.treatedTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.treatedTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)setUpSegmentedControl{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    self.segmentedControl.sectionTitles = @[@"未处理", @"已处理"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:20/255.0 green:153/255.0 blue:231/255.0 alpha:1],NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]};
    self.segmentedControl.selectionIndicatorHeight=3.0;
    self.segmentedControl.selectionIndicatorColor =[UIColor colorWithRed:20/255.0 green:153/255.0 blue:231/255.0 alpha:1];
    self.segmentedControl.borderType=HMSegmentedControlBorderTypeBottom;
    self.segmentedControl.borderWidth=3.0;
    self.segmentedControl.borderColor=[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index==1) {
            if (weakSelf.treatedArr.count) {
                weakSelf.rightBtn.hidden=NO;
            }else{
                weakSelf.rightBtn.hidden=YES;
            }
            
        }else{
            
            weakSelf.rightBtn.hidden=YES;
            
        }
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, self.view.frame.size.height-50) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, self.view.frame.size.height-50)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2, self.view.frame.size.height-50);
    self.scrollView.delegate = self;
    
    self.baseNdView=[[BaseNoDataView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, CGRectGetHeight(self.scrollView.frame))];
    
    self.untreatedTableView.frame=CGRectMake(0, 0, viewWidth, CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:self.untreatedTableView];
    
    
    self.baseNdView2=[[BaseNoDataView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, CGRectGetHeight(self.scrollView.frame))];
    self.treatedTableView.frame = CGRectMake(viewWidth, 0, viewWidth, CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:self.treatedTableView];
    
    [self judgeNoDataViewIsShow];
    
    [self.view addSubview:self.scrollView];
    
    
}

//判断是否显示nodataView
- (void)judgeNoDataViewIsShow{
    
    if (self.untreatedArr.count==0) {
        [self.untreatedTableView addSubview:self.baseNdView];
    }else{
        [self.baseNdView removeFromSuperview];
    }
    
    if (self.treatedArr.count==0) {
        [self.treatedTableView addSubview:self.baseNdView2];
        
    }else{
        
        [self.baseNdView2 removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.untreatedTableView) {
        return 2;
    }
    return self.treatedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image=[UIImage imageNamed:@"work_nomal_13"];
    cell.textLabel.font  = [UIFont boldSystemFontOfSize:17.0];
    cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:14.0];
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    if (tableView ==self.untreatedTableView) {
        cell.textLabel.text =@"产值复核";
        cell.detailTextLabel.text=@"请您对公司当月产值进行复核";
    }else{
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.text =@"产值复核";
        cell.detailTextLabel.text=@"请您对公司当月产值进行复核";
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.untreatedTableView) {
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    if (page==1) {
        if (self.treatedArr.count) {
            self.rightBtn.hidden=NO;
        }else{
            self.rightBtn.hidden=YES;
        }
        
    }else{
        
        self.rightBtn.hidden=YES;
        
    }
    
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
}

@end