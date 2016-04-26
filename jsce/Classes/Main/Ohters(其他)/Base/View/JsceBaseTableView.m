//
//  JsceBaseTableView.m
//  jsce
//
//  Created by mac on 15/9/15.
//  Copyright (c) 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseTableView.h"

@implementation JsceBaseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style       {
    if (self = [super initWithFrame:frame style:style]) {
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [self setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [self setLayoutMargins:UIEdgeInsetsZero];
            
        }
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
 
    }
    return self;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)reloadEmptyDataSetWithTypeStyle:(TypeStyle)typeStyle{
    self.typeStyle = typeStyle;
    [self reloadEmptyDataSet];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    switch (self.typeStyle) {
        case NoData:
        {
            text = @"没有更多数据了";
            font = [UIFont systemFontOfSize:16.0];
            textColor = [UIColor hexFloatColor:@"d9dce1"];
            break;
        }
        case NoNetWork:
        {
            text = @"请检查你的网络";
            font = [UIFont systemFontOfSize:13.0];
            textColor = [UIColor hexFloatColor:@"555555"];
            break;
        }
        case Loading:
        {
            text = @"正在加载数据中...";
            font = [UIFont systemFontOfSize:12.0];
            textColor = [UIColor hexFloatColor:@"555555"];
            break;
        }
              default:
            return nil;
    }
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    switch (self.typeStyle) {

        case NoNetWork:
        {
            text = @"您的网络好像有问题";
            font = [UIFont systemFontOfSize:16.0];
            textColor = [UIColor hexFloatColor:@"555555"];
            break;
        }
        default:
            return nil;
    }

    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }
    else {
        NSString *imageName;
        switch (self.typeStyle) {
            case Loading:
            {
              imageName = @"loading_imgBlue_78x78";
                break;
            }
            case NoData:
            {
                imageName = @"no_message_coffee";
                break;
            }
            case NoNetWork:
            {
                imageName = @"placeholder_remote";
                break;
            }
                
            default:
                break;
        }
        
        return [UIImage imageNamed:imageName];
    }
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    

    switch (self.typeStyle) {
        case NoNetWork:
        {
            text = @"重新加载";
            font = [UIFont systemFontOfSize:13.0];
            textColor = [UIColor hexFloatColor:(state == UIControlStateNormal) ? @"05adff" : @"6bceff"];

            break;
        }
            
        default:
            break;
    }
    
    if (!text) {
        return nil;
    }

    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName;
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
   return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -30;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.loading = YES;
    [self reloadEmptyDataSet];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refresh();
        self.loading = NO;
    });
 

}



@end
