//
//  GroupHeaderView.h
//  jsce
//
//  Created by mac on 15/10/22.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupHeaderView;
@class MultiSelectItem;
@protocol GroupHeaderViewDelegate <NSObject>

- (void)willDeleteRowWithItem:(MultiSelectItem*)item withMultiSelectedPanel:(GroupHeaderView*)multiSelectedPanel;

- (void)updateConfirmButton;

@end
@interface GroupHeaderView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic,strong) UICollectionView  *collectionView;

@property (nonatomic, weak) id<GroupHeaderViewDelegate> delegate;

@end
