//
//  MultiSelectedPanel.h
//  MultiSelectTableViewController
//
//  Created by molon on 6/8/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiSelectedPanel;
#import "UserProfileManager.h"
@protocol MultiSelectedPanelDelegate <NSObject>

- (void)willDeleteRowWithItem:(UserProfileEntity *)user withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;

- (void)updateConfirmButton;

@end

@interface MultiSelectedPanel : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//+ (instancetype)instanceFromNib;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<MultiSelectedPanelDelegate> delegate;

@property (nonatomic,strong) UICollectionView  *collectionView;


//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
