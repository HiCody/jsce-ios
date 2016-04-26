//
//  MultilevelMenu.h
//  Filter
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLeftWidth 150
@interface MultilevelMenu : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic,readonly) NSArray * allData;

@property(strong,nonatomic)NSArray *firstColumnArr;

@property(strong,nonatomic)NSArray *secondColumnArr;

@property(copy,nonatomic,readonly) id block;

/**
 *  是否 记录滑动位置
 */
@property(assign,nonatomic) BOOL isRecordLastScroll;
/**
 *   记录滑动位置 是否需要 动画
 */
@property(assign,nonatomic) BOOL isRecordLastScrollAnimated;

@property(assign,nonatomic,readonly) NSInteger selectIndex;

/**
 *  为了 不修改原来的，因此增加了一个属性，选中指定 行数
 */
@property(assign,nonatomic) NSInteger needToScorllerIndex;
/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * leftBgColor;
/**
 *  左边点中文字颜色
 */
@property(strong,nonatomic) UIColor * leftSelectColor;
/**
 *  左边点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftSelectBgColor;

/**
 *  左边未点中文字颜色
 */

@property(strong,nonatomic) UIColor * leftUnSelectColor;
/**
 *  左边未点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * leftSeparatorColor;

@property(assign,nonatomic)  NSInteger selectedRightIndex;

@property(assign,nonatomic)  NSInteger lastLeftIndex;

-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray*)data withSelectIndex:(void(^)(NSInteger left,NSInteger right,id info))selectIndex;

-(void)reloadData;
@end

