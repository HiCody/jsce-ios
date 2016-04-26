//
//  IndustryCircleMainVC.m
//  jsce
//
//  Created by mac on 15/9/14.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "IndustryCircleMainVC.h"
#import "HMSegmentedControl.h"
#import "ICHeadView.h"
#import "ICPreferencViewController.h"
#import "ICTableViewCell.h"
#import "ICReplyBody.h" 
#import "ICMessageBody.h"
#import "ICTextData.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ICDetailInfoVC.h"
#import "ICPersonalInfoVC.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0

#define kAdmin @"小虎-tiger"

@interface IndustryCircleMainVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,cellDelegate>{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    NSInteger _replyIndex;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic,strong)UITableView *demandTableView;//需求动态页面
@property (nonatomic,strong)UITableView *anonymousTableView;//匿名吐槽页面
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong)ICHeadView *icHeadView;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation IndustryCircleMainVC
- (NSMutableArray *)photos{
    if (!_photos) {
        _photos = [[NSMutableArray alloc]init];
    }
    return _photos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"行业圈";
    self.automaticallyAdjustsScrollViewInsets=NO;

    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    [self setUpTableView];
    [self setUpSegment];
    [self setUpNaviBarItem];
    
    [self configData];
 
    [self loadTextData];
}

- (void)configData{
    ICReplyBody *body1 = [[ICReplyBody alloc] init];
    body1.replyUser = kAdmin;
    body1.repliedUser = @"红领巾";
    body1.replyInfo = kContentText1;
    
    
    ICReplyBody *body2 = [[ICReplyBody alloc] init];
    body2.replyUser = @"迪恩";
    body2.repliedUser = @"";
    body2.replyInfo = kContentText2;
    
    ICMessageBody *messBody1 = [[ICMessageBody alloc] init];
    messBody1.posterContent = kShuoshuoText1;
    messBody1.posterPostImage = @[@"http://img0.hao123.com/data/1_01ee4ce4399e09bc1163570fd2b0dd81_510"];
    messBody1.posterImgstr = @"http://www.qqzhi.com/uploadpic/2014-09-27/015945470.jpg";
    messBody1.releaseTime = @"1天前";
    messBody1.posterName = @"名侦探柯南";
    messBody1.post = @"无锡公司";
    messBody1.isVip =YES;
    messBody1.posterReplies = [NSMutableArray arrayWithObjects:body1,body2, nil];
    messBody1.locationStr=@"无锡";
    messBody1.posterFavour = [NSMutableArray arrayWithObjects:@"希尔瓦娜斯",kAdmin,@"鹿盔", nil];
    messBody1.isFavour = YES;
    
    ICMessageBody *messBody2 = [[ICMessageBody alloc] init];
    messBody2.posterContent = kContentText5;
    messBody2.releaseTime = @"2天前";
    messBody2.posterPostImage = @[@"http://img6.hao123.com/data/1_198e81bf35d1fcf9dfd51110f1553bf6_0",
                                  @"http://img0.hao123.com/data/1_01ee4ce4399e09bc1163570fd2b0dd81_510",
                                  @"http://img6.hao123.com/data/1_9f90f480bfd4fc6091591c9a42ae8b26_510",
                                  @"http://img2.hao123.com/data/1_f1746b5fd5756ac72b87a702f6ed1e6b_510",
                                  @"http://img6.hao123.com/data/1_b26f06dce810de9d3b358df4c997ac3a_510",
                                  @"http://img4.hao123.com/data/1_d77c983a8be840d0c9fffbb987e9f724_0",
                                  @"http://img0.hao123.com/data/1_e588cb06859ad7689cd34c0e13e0a96f_510",
                                  @"http://img5.hao123.com/data/1_4f71e8280847c3ac6ffea73f42ec9737_0",
                                  @"http://img.hao123.com/data/1_45d543cb0b072660997b3d977079298f_510"];
    messBody2.posterReplies = [NSMutableArray arrayWithObjects:body1,body2, nil];
    messBody2.posterImgstr = @"http://img2.100bt.com/upload/ttq/20130811/1376226186257_middle.jpg";
    messBody2.posterName = @"火影鸣人";
    messBody2.post = @"北京公司";
    messBody2.locationStr=@"无锡";
    messBody2.posterFavour = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    messBody2.isFavour = NO;
    
    
    ICMessageBody *messBody3 = [[ICMessageBody alloc] init];
    messBody3.posterContent = kShuoshuoText4;
    messBody3.posterImgstr = @"http://qq1234.org/uploads/allimg/140519/3_140519092805_12.jpg";
    messBody3.releaseTime = @"1天前";
    messBody3.posterName = @"小兰";
    messBody3.post = @"无锡公司";
    messBody3.isVip =YES;
       messBody3.posterReplies = [NSMutableArray arrayWithObjects:body1,body2, nil];
    messBody3.locationStr=@"无锡";
    messBody3.posterFavour = [NSMutableArray array];
    messBody3.isFavour = NO;
    
    ICMessageBody *messBody4 = [[ICMessageBody alloc] init];
    messBody4.posterContent = kShuoshuoText6;
    messBody4.posterImgstr = @"http://img.135q.com/2015-04/06/142832479700011.jpg";
    messBody4.releaseTime = @"1天前";
    messBody4.posterName = @"路飞";
    messBody4.posterReplies = [NSMutableArray arrayWithObjects:body1,body2, nil];
    messBody4.post = @"无锡公司";
    messBody4.isVip =YES;
    messBody4.locationStr=@"南京";
    messBody4.isFavour = NO;
    messBody4.posterFavour = [NSMutableArray arrayWithObjects:@"塞纳留斯",@"希尔瓦娜斯",@"鹿盔", nil];
    
    ICMessageBody *messBody5 = [[ICMessageBody alloc] init];
    messBody5.posterContent = kShuoshuoText4;
    messBody5.posterImgstr = @"http://e.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=65708e79237f9e2f7060150c2a00c512/d788d43f8794a4c2b9e5dbb40af41bd5ac6e396e.jpg";
    messBody5.releaseTime = @"1天前";
    messBody5.posterName = @"海贼王路飞";
    messBody5.post = @"无锡公司";
    messBody5.isVip =YES;
    messBody5.locationStr=@"无锡";
    messBody5.posterFavour = [NSMutableArray array];
    messBody5.posterReplies =[NSMutableArray array];
    messBody5.isFavour = NO;

    
    [_contentDataSource addObject:messBody1];
    [_contentDataSource addObject:messBody2];
     [_contentDataSource addObject:messBody3];
    [_contentDataSource addObject:messBody4];
    [_contentDataSource addObject:messBody5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置导航栏上左右按钮
- (void)setUpNaviBarItem{
    [self actionCustomLeftBtnWithNrlImage:@"favorites" htlImage:nil title:nil action:^{
        
    }];
    
    [self actionCustomRightBtnWithNrlImage:@"industal_ publish" htlImage:nil title:nil action:^{
        
    }];
}

//设置导航条上的segment
- (void)setUpSegment{
     CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, W(220), 35)];
    self.segmentedControl.sectionTitles = @[@"行业动态", @"匿名吐槽"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    self.segmentedControl.selectionIndicatorColor=[UIColor whiteColor];
    self.segmentedControl.selectionIndicatorHeight=2.0;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {

        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, self.view.frame.size.height-50) animated:YES];
    }];
    
    self.navigationItem.titleView=self.segmentedControl;

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height-115)];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(viewWidth * 2,self.view.frame.size.height-115);
    self.scrollView.delegate = self;
    self.scrollView.bounces=NO;
    
     [self.view addSubview:self.scrollView];
 //添加偏好设置
    self.icHeadView=[ICHeadView ICHeadView];
    self.icHeadView.frame=CGRectMake(0, 0, viewWidth, 35);
    [self.icHeadView.preferenceButton addTarget:self action:@selector(choosePreference:) forControlEvents:UIControlEventTouchUpInside];

    self.demandTableView.frame=CGRectMake(0, 0, viewWidth, CGRectGetHeight(self.scrollView.frame));
     self.demandTableView.tableHeaderView =  self.icHeadView;
    [self.scrollView addSubview:self.demandTableView];
  
    self.anonymousTableView.frame = CGRectMake(viewWidth, 0, viewWidth, CGRectGetHeight(self.scrollView.frame));
    [self.scrollView addSubview:self.anonymousTableView];

}

//跳转到偏好设置界面
- (void)choosePreference:(UIButton *)btn{
    ICPreferencViewController *icpVC=[[ICPreferencViewController alloc] init];
    icpVC.hidesBottomBarWhenPushed  = YES;
    icpVC.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController pushViewController:icpVC animated:YES];
}

- (void)setUpTableView{
    self.demandTableView=[[UITableView alloc] init];
    self.demandTableView.delegate = self;
    self.demandTableView.dataSource = self;
    self.demandTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.demandTableView.bounces=NO;

    
    self.anonymousTableView=[[UITableView alloc] init];
    self.anonymousTableView.delegate = self;
    self.anonymousTableView.dataSource = self;
    self.anonymousTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.anonymousTableView.bounces=NO;
}

#pragma mark -加载数据
- (void)loadTextData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * icDataArray =[[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
            
            ICMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
            ICTextData *icData = [[ICTextData alloc] init ];
            icData.messageBody = messBody;
            
            [icDataArray addObject:icData];
            
        }
        [self calculateHeight:icDataArray];
        
    });
}

#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    
    
    NSDate* tmpStartData = [NSDate date];
    
    for (ICTextData *icData in dataArray) {
        
        icData.shuoshuoHeight = [icData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        icData.unFoldShuoHeight = [icData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        icData.replyHeight = [icData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        icData.favourHeight = [icData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:icData];
        
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
     
        [self.demandTableView reloadData];
        
    });
    
    
}


#pragma  mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ICTextData *icTextData = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = icTextData.foldOrNot;
    
    CGFloat distance=(icTextData.replyDataSource.count==0&&icTextData.favourArray.count==0)?0:kReplyBtnDistance;
    
    return 10+TableHeader+(unfold?icTextData.shuoshuoHeight:icTextData.unFoldShuoHeight)+kShuoshuoDistance+(icTextData.islessLimit?0:(kFoldBtnDistance+20))+(icTextData.showImageHeight==0?0:(icTextData.showImageHeight))+kLocationDistance+18+30+icTextData.favourHeight+distance+icTextData.replyHeight+kBottom;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"cell";
    
    ICTableViewCell *cell = (ICTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ICTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    
    cell.replyBtn.appendIndexPath=indexPath;
    cell.favourBtn.appendIndexPath=indexPath;
    
 
    
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favourBtn addTarget:self action:@selector(addLike:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    cell.icTextData =  [_tableDataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - 收藏
- (void)addLike:(ICButton *)btn{
    _selectedIndexPath=btn.appendIndexPath;
    
    ICTextData *icData = (ICTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    ICMessageBody *m = icData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    icData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [icData.attributedDataFavour removeAllObjects];
    
    
    icData.favourHeight = [icData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:icData];
    
    [self.demandTableView reloadData];
    
}

#pragma mark 回复
- (void)replyAction:(ICButton *)btn{
    
}


#pragma mark -cellDelegate
//全文或者收起
- (void)changeFoldState:(ICTextData *)ictd onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ictd];
    [self.demandTableView reloadData];
    
}

//图片展示
- (void)showImageViewWithImageViews:(NSArray *)imageViews andImageArray:(NSArray *)imageArray byClickWhich:(NSInteger)clickTag{
    
    NSInteger count = imageArray.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {

        NSString *url = imageArray[i] ;
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = imageViews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = clickTag-100; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

//头像跳转详细页面
- (void)segueToPersonalInfoWith:(ICTextData *)icTextData{
    ICPersonalInfoVC *icPVC=[[ICPersonalInfoVC alloc] init];
    icPVC.messageBody  = icTextData.messageBody;
    icPVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:icPVC animated:YES];
    
}

#pragma mark - UIScrollViewDelegate 滑动后切换
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==self.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    }

}

@end
