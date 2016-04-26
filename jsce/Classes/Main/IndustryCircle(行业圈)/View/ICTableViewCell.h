//
//  ICTableViewCell.h
//  jsce
//
//  Created by mac on 15/9/21.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICTextData.h"
#import "ICTextView.h"
#import "ICButton.h"

@protocol cellDelegate <NSObject>

- (void)changeFoldState:(ICTextData *)icTextData onCellRow:(NSInteger) cellStamp;

- (void)showImageViewWithImageViews:(NSArray *)imageViews andImageArray:(NSArray *)imageArray byClickWhich:(NSInteger)clickTag;

- (void)segueToPersonalInfoWith:(ICTextData *)icTextData;
@end

@interface ICTableViewCell : UITableViewCell<ICCoretextDelegate>
@property (nonatomic,strong) NSMutableArray * imageArray; //展示图片数组
@property (nonatomic,strong) NSMutableArray * icFavourArray; //收藏人名数组
@property (nonatomic,strong) NSMutableArray * icShuoshuoArray;
@property (nonatomic,strong) NSMutableArray * icTextArray;
@property (nonatomic,strong) UIImageView *favourImage;//收藏的图
@property (nonatomic,strong) ICTextData  *icTextData;
@property (nonatomic,strong) ICButton *replyBtn;//回复按钮
@property (nonatomic,strong) UIImageView *replyImage;

@property (nonatomic,strong) ICButton *favourBtn;


@property (nonatomic,strong) UIImageView *locationImage;//地理位置图片

@property (nonatomic,assign) BOOL isVip;
@property (nonatomic,strong) UIImageView *vipImage;

@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,assign) id<cellDelegate> delegate;
/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  用户所属公司label
 */
@property (nonatomic,strong) UILabel *userCompanyLbl;

/**
 *  提交时间
 */
@property (nonatomic,strong) UILabel *commitTimeLbl;

/**
 *  地理位置
 */
@property (nonatomic,strong) UILabel *locationLbl;
@end
