//
//  GroupHeaderView.m
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "GroupHeaderView.h"
#import "GroupCollectionViewLayout.h"
#import "GroupHeaderCollectionViewCell.h"
#import "MultiSelectItem.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0
#define Duration 0.2

#define ItemWidth W(55)
#define ItemHeight 90
@implementation GroupHeaderView{
    NSIndexPath *currentIndexPath;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        GroupCollectionViewLayout *flowLayout=[[GroupCollectionViewLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20,self.frame.size.width, 100) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator =  NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate =  self;
        
       // self.collectionView.alwaysBounceHorizontal=YES;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GroupHeaderViewCell"];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

#pragma mark - setter
- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems = selectedItems;
    
    [self.collectionView reloadData];
    
    //[self updateConfirmButton];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupHeaderViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    //添加一个imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,ItemWidth, ItemWidth)];
    imageView.tag = 999;
    imageView.layer.cornerRadius = 4.0f;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
    
    
    //    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    
  //  MultiSelectItem *item = self.selectedItems[indexPath.row];
    //   [imageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl]];
    imageView.image = [UIImage imageNamed:@"头像1"];
    
    
   UILabel *nameLable  =  [[UILabel alloc]  initWithFrame:CGRectMake(0, ItemWidth+5, ItemWidth, 13)];
    nameLable.font = [UIFont systemFontOfSize:13.0];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.text = @"1111";
    [cell.contentView addSubview:nameLable];

    return cell;
}


#pragma mark  -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) { //委托给控制器   删除列表中item
        [self.delegate willDeleteRowWithItem:item withMultiSelectedPanel:self];
    }
    
    
    //确定没了删掉
    if ([self.selectedItems indexOfObject:item]==NSNotFound) {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
            [self.delegate updateConfirmButton];
        }
        
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    }
    
}

#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
        [self.delegate updateConfirmButton];
    }
    
    //执行删除操作
    
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(updateConfirmButton)]) {
            [self.delegate updateConfirmButton];
        }
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        currentIndexPath = indexPath;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        
    }
}




@end
