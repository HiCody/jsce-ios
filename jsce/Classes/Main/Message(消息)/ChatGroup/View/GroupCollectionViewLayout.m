//
//  GroupCollectionViewLayout.m
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "GroupCollectionViewLayout.h"

#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height

#define W(x) WinWidth*x/320.0
#define H(y) WinHeight*y/568.0


#define ItemWidth W(55)
#define ItemHeight 90


@implementation GroupCollectionViewLayout

//准备布局,最先调用该方法
-(void)prepareLayout{
    [super prepareLayout];
    _cellCount=[self.collectionView numberOfItemsInSection:0];
    
    
}


//对每一个cell的进行布局
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //某个cell的布局和属性
    UICollectionViewLayoutAttributes *attribues=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    NSInteger row=indexPath.row/4;
    NSInteger col=indexPath.row%4;
    
    CGFloat padding = (screenWidth - ItemWidth*4)/5.0;
    
    
    CGFloat x  = padding*(col+1)+ItemWidth*col;
    CGFloat y  = ItemHeight*row;
    
    attribues.frame =CGRectMake(x, y, ItemWidth, ItemHeight);
    
    return attribues;
}


//区域内布局，返回所有cell的布局的信息
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributes=[NSMutableArray array];
    for (NSInteger i=0;i<self.cellCount;i++) {
        NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:path]];
    }
    return attributes;
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



//- (CGSize)collectionViewContentSize
//
//{
//    
//    CGSize contentSize = CGSizeMake(screenWidth, _sectionCount*100);
//    
//    return contentSize;
//    
//}


@end
