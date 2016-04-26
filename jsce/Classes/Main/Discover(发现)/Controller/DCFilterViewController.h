//
//  DCFilterViewController.h
//  jsce
//
//  Created by mac on 15/9/28.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "JsceBaseVC.h"
@interface DCFilterViewController : JsceBaseVC
/**
 *  第一列数据
 */
@property(strong,nonatomic)NSArray *firstColumnArr;


/**
 *  第二列数据
 */
@property(strong,nonatomic)NSArray *secondColumnArr;

@property(copy,nonatomic)void(^refreshByFilter)(NSInteger index,NSIndexPath *filterIndexPath);
@end
