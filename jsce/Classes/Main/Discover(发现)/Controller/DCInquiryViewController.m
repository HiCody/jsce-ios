//
//  DCInquiryViewController.m
//  jsce
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "DCInquiryViewController.h"
#import "EYTagView.h"
#import "DiscoverModel.h"
#import "DCSearchModel.h"
#define kEdgePadding 10
#define KSectionIndexBackgroundColor  [UIColor clearColor] //索引试图未选中时的背景颜色
#define kSectionIndexTrackingBackgroundColor [UIColor lightGrayColor]//索引试图选中时的背景
#define kSectionIndexColor [UIColor grayColor]//索引试图字体颜色
#define BGCOLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
@interface DCInquiryViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,EYTagViewDelegate>{
    NSUserDefaults *userDefaults;
}

@property (strong, nonatomic) UITextField *searchText;

@property (strong, nonatomic) UIView *tableHeaderView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *clearHistoryBtn;

@property(nonatomic,strong)UILabel *noHistoryLable;

@property (strong, nonatomic)EYTagView *tagView;

@property(strong,nonatomic)NSMutableArray *searchArr;

@property(strong,nonatomic)NSMutableArray *historyArr;

@end

@implementation DCInquiryViewController
- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr=[[NSMutableArray alloc] init];
    }
    return _searchArr;
}

- (NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [[NSMutableArray alloc] init];
    }
    return _historyArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self getSearchHistory];
    
    [self configNaviBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configNaviBar{
    //自定义导航栏
    UIView *customNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    customNavView.backgroundColor = BGCOLOR;
    
    CGSize cancleSize=[self sizeWithText:@"取消" font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

    UIButton *cancleBtn=[[UIButton alloc] initWithFrame:CGRectMake(screenWidth-cancleSize.width-10, (44-32)/2.0+20, cancleSize.width, 32)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [customNavView addSubview:cancleBtn];
    //3自定义背景
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(20, (44-30)/2.0+20, screenWidth-20-cancleSize.width-5-10, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchView.layer.borderWidth = 0.5;

    //搜索框
    _searchText = [[UITextField alloc]initWithFrame:CGRectMake(10, (searchView.frame.size.height-30)/2.0, CGRectGetWidth(searchView.frame)-20, 30)];
    _searchText.backgroundColor = [UIColor whiteColor];
    _searchText.font = [UIFont systemFontOfSize:13];
    _searchText.placeholder  = @"请输入名称或首字母查询";
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.textColor    = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:1];
    _searchText.delegate     = self;
    [_searchText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_searchText];
    
    [customNavView addSubview:searchView];
    
    
    [self.view addSubview:customNavView];
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.frame           = CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height-64);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    [self.view addSubview:_tableView];
    
    [self ininHeaderView];
    
    //添加单击事件 取消键盘第一响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirstResponder:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

//保存历史记录
-(void)saveSearchHistory:(NSString *)searchString{
    NSInteger index=0;
    for (NSString *str in self.historyArr) {
        if ([str isEqualToString:searchString]) {
            index++;
        }
    }
    if (!index) {
        if(self.historyArr.count<7){
            
            [self.historyArr addObject:searchString];
            
        }else{
            
            [self.historyArr removeLastObject];
            [self.historyArr insertObject:searchString atIndex:0];
            
        }

    }else{
        [self.historyArr removeObject:searchString];
        [self.historyArr insertObject:searchString atIndex:0];
    }
    
    [userDefaults setObject:self.historyArr forKey:@"SearchHistory"];
}

//获取搜索历史
-(void)getSearchHistory
{
    NSArray *strCommonCity = [userDefaults arrayForKey:@"SearchHistory"];
    
    [self.historyArr addObjectsFromArray:strCommonCity];
    for (NSString *str in self.historyArr) {
        NSLog(@"%@",str);
    }
    
}


#pragma mark 手势方法
- (void)resignFirstResponder:(UITapGestureRecognizer*)tap
{
    [_searchText resignFirstResponder];
    
}

#pragma mark UITextfield
- (void)textChange:(UITextField*)textField
{
    [self filterContentForSearchText:textField.text];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self filterContentForSearchText:textField.text];
    [textField resignFirstResponder];
    return YES;
    
}

#pragma mark Button
- (void)popBack:(UIButton *)btn{
    [self.searchText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterContentForSearchText:(NSString*)searchText {
    if (searchText.length > 0) {
        
        [self requestData];
    
    }else{
        [self.searchArr removeAllObjects];
        _tableView.tableHeaderView = _tableHeaderView;
        [self changeTablefFooterView];
        [_tableView reloadData];
    }
}

- (void)ininHeaderView
{
    _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 250)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //热门搜素
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(kEdgePadding, 10, 160, 21)];
    title.text = @"热门搜索";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor lightGrayColor];
    [_tableHeaderView addSubview:title];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(kEdgePadding, 36, screenWidth-kEdgePadding*2, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [_tableHeaderView addSubview:lineView];
    
    self.tagView  = [[EYTagView alloc] initWithFrame:CGRectMake(kEdgePadding, CGRectGetMaxY(lineView.frame)+8, screenWidth-kEdgePadding*2, 278)];
    [self setUpTagView];
    [_tableHeaderView addSubview:self.tagView];
    
    UIView *lineView3=[[UIView alloc] initWithFrame:CGRectMake(kEdgePadding, CGRectGetMaxY(self.tagView.frame)+15, screenWidth-kEdgePadding*2, 0.5)];
    lineView3.backgroundColor=[UIColor lightGrayColor];
    [_tableHeaderView addSubview:lineView3];
    
    //历史记录
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(kEdgePadding, CGRectGetMaxY(lineView3.frame)+20, 160, 21)];
    title2.text = @"历史搜索";
    title2.font = [UIFont systemFontOfSize:14];
    title2.textColor = [UIColor lightGrayColor];
    [_tableHeaderView addSubview:title2];
    
    UIView *lineView2=[[UIView alloc] initWithFrame:CGRectMake(kEdgePadding, CGRectGetMaxY(title2.frame)+5, screenWidth-kEdgePadding*2, 0.5)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [_tableHeaderView addSubview:lineView2];
    
    _tableHeaderView.frame = CGRectMake(0, 0, screenWidth, CGRectGetMaxY(lineView2.frame)+2);
    
    _tableView.tableHeaderView.frame = _tableHeaderView.frame;
    _tableView.tableHeaderView = _tableHeaderView;
    
    [self changeTablefFooterView];
}

- (void)changeTablefFooterView{
    //底部清除历史按钮
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    footerView.backgroundColor=[UIColor clearColor];

    self.clearHistoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, screenWidth, 39)];
    self.clearHistoryBtn.backgroundColor=[UIColor clearColor];
    [self.clearHistoryBtn setTitle:@"清除历史" forState:UIControlStateNormal];
    self.clearHistoryBtn.enabled=YES;
    [self.clearHistoryBtn  addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearHistoryBtn setTitleColor:COLORRGB(0x2ab44e) forState:UIControlStateNormal];
    self.clearHistoryBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    self.noHistoryLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, screenWidth, 39)];
    self.noHistoryLable.textColor=[UIColor grayColor];
    self.noHistoryLable.font=[UIFont systemFontOfSize:14.0];
    self.noHistoryLable.text = @"暂无搜索历史记录";
    self.noHistoryLable.textAlignment = NSTextAlignmentCenter;
    if (!self.historyArr.count) {
        
        [footerView addSubview:self.noHistoryLable];
        
    }else{
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(kEdgePadding, 0, screenWidth-kEdgePadding*2, 0.5)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [footerView addSubview:lineView];
        [footerView addSubview:self.clearHistoryBtn];
    }
  //  _tableView.tableFooterView.frame = footerView.frame;
    _tableView.tableFooterView = footerView;
}

- (void)clearHistory:(UIButton *)btn{
    [self.historyArr removeAllObjects];
    [userDefaults setObject:self.historyArr forKey:@"SearchHistory"];
    [self changeTablefFooterView];
    [self.tableView reloadData];
}

- (void)setUpTagView{
    _tagView.delegate=self;
    
    _tagView.colorTag=COLORRGB(0xffffff);
    _tagView.colorTagBg=COLORRGB(0x2ab44e);
    _tagView.colorInput=COLORRGB(0x2ab44e);
    _tagView.colorInputBg=COLORRGB(0xffffff);
    _tagView.colorInputPlaceholder=COLORRGB(0x2ab44e);
    _tagView.backgroundColor=COLORRGB(0xffffff);
    _tagView.colorInputBoard=COLORRGB(0x2ab44e);
    _tagView.viewMaxHeight=150;
    _tagView.fontTag=[UIFont systemFontOfSize:14.0];
    _tagView.tagHeight = 30;
    _tagView.type=EYTagView_Type_Single_Selected;
    [_tagView addTags:@[
                        @"土木工程",
                        @"工程测量",
                        @"标准应用技术规范",
                        @"地下防水",
                        @"冬期技术",
                        @"设计规范",
                        @"施工质量",
                        @"验收规范",
                        @"安全",
                                    ]];

}

-(void)heightDidChangedTagView:(EYTagView *)tagView{
    NSLog(@"heightDidChangedTagView");
}

- (void)searchWithButtonTitle:(NSString *)titleStr{
    self.searchText.text = titleStr;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchArr.count) {
         return self.searchArr.count;
    }else{
        return self.historyArr.count;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.searchArr.count) {
        LawSearchModel *lawSearchModel=self.searchArr[indexPath.row];
        cell.textLabel.text=lawSearchModel.title;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor =[UIColor grayColor];
    }else{
        cell.textLabel.text=self.historyArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor =[UIColor grayColor];

    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {        [cell setSeparatorInset:UIEdgeInsetsMake(kEdgePadding, kEdgePadding, kEdgePadding, kEdgePadding)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {        [cell setLayoutMargins:UIEdgeInsetsMake(kEdgePadding, kEdgePadding, kEdgePadding, kEdgePadding)];
    }

    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)requestData{
    [DiscoverModel requestLawsInfoTitleSearchWithTitle:self.searchText.text Success:^(AFHTTPRequestOperation *operation, id result) {
        NSDictionary *dict =  result;
        NSArray *itemsArr = dict[@"items"];
        NSArray *tempArr= [LawSearchModel objectArrayWithKeyValuesArray:itemsArr];
        [self.searchArr addObjectsFromArray:tempArr];
        
        if (self.searchArr.count) {
            _tableView.tableHeaderView = nil;
            _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [self saveSearchHistory:self.searchText.text];
            [self.tableView reloadData];
        }
        
       
    } failure:^(NSError *error) {
        
    }];
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
@end
