//
//  ICTextView.h
//  jsce
//
//  Created by mac on 15/9/17.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ICCoretextDelegate <NSObject>

- (void)clickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index;

- (void)longClickWFCoretext:(NSString *)clickString replyIndex:(NSInteger)index;

@end

@interface ICTextView : UIView

@property(nonatomic,strong)NSAttributedString *attrEmotionString;

@property (nonatomic,strong) NSArray *emotionNames;
@property (nonatomic,assign) BOOL isDraw;
@property (nonatomic,assign) BOOL isFold;//是否折叠
@property (nonatomic,strong) NSMutableArray *attributedData;
@property (nonatomic,assign) int textLine;
@property (nonatomic,assign) id<ICCoretextDelegate>delegate;
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@property (nonatomic,assign) BOOL canClickAll;//是否可点击整段文字
@property (nonatomic,assign) NSInteger replyIndex;
@property (nonatomic,assign) NSInteger fontInteger;
@property (nonatomic,strong) UIColor *textColor;

- (void)setOldString:(NSString *)oldString andNewString:(NSString *)newString;

- (int)getTextLines;

- (float)getTextHeight;



@end
