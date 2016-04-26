//
//  ICTextData.m
//  jsce
//
//  Created by mac on 15/9/17.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "ICTextData.h"
#import "ICReplyBody.h"
#import "RegularExpressionManager.h"
#import "NSString+Subsitute.h"
#import "NSArray+Subsitute.h"
#import "ICTextView.h"
@implementation ICTextData{
    
    TypeView typeview;
    int tempInt;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.completionReplySource = [[NSMutableArray alloc] init];
        self.attributedDataReply = [[NSMutableArray alloc] init];
        self.attributedDataShuoshuo = [[NSMutableArray alloc] init];
        self.attributedDataFavour = [[NSMutableArray alloc] init];
        
        _foldOrNot = YES;
        _islessLimit = NO;
        
    }
    return self;
}


- (void)setMessageBody:(ICMessageBody *)messageBody{
    
    _messageBody = messageBody;
    _showImageArray = messageBody.posterPostImage;
    _foldOrNot = YES;
    _showShuoShuo = messageBody.posterContent;
    _defineAttrData = [self findAttrWith:messageBody.posterReplies];
    _replyDataSource = messageBody.posterReplies;
    _favourArray = messageBody.posterFavour;
    _hasFavour = messageBody.isFavour;
}


//保存回复人和被回复人的range
- (NSMutableArray *)findAttrWith:(NSMutableArray *)replies{
    
    NSMutableArray *feedBackArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < replies.count; i++) {
        ICReplyBody *replyBody = (ICReplyBody *)[replies objectAtIndex:i];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        if ([replyBody.repliedUser isEqualToString:@""]) {
            
            NSString *range = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            [tempArr addObject:range];
            
        }else{
            NSString *range1 = NSStringFromRange(NSMakeRange(0, replyBody.replyUser.length));
            NSString *range2 = NSStringFromRange(NSMakeRange(replyBody.replyUser.length + 2, replyBody.repliedUser.length));
            [tempArr addObject:range1];
            [tempArr addObject:range2];
        }
        [feedBackArray addObject:tempArr];
    }
    return feedBackArray;
    
}

- (void)matchString:(NSString *)dataSourceString fromView:(TypeView) isReplyV{
    
    if (isReplyV == TypeReply) {
        
        NSMutableArray *totalArr = [NSMutableArray arrayWithCapacity:0];
        
        //**********号码******
        
        NSMutableArray *mobileLink = [RegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            
            [totalArr addObject:[mobileLink objectAtIndex:i]];
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [RegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [totalArr addObject:[webLink objectAtIndex:i]];
        }
        
        //******自行添加**********
        
        if (_defineAttrData.count != 0) {
            NSArray *tArr = [_defineAttrData objectAtIndex:tempInt];
            for (int i = 0; i < [tArr count]; i ++) {
                NSString *string = [dataSourceString substringWithRange:NSRangeFromString([tArr objectAtIndex:i])];
                [totalArr addObject:[NSDictionary dictionaryWithObject:string forKey:NSStringFromRange(NSRangeFromString([tArr objectAtIndex:i]))]];
            }
            
        }
        
        
        //***********************
        [self.attributedDataReply addObject:totalArr];
        
        
    }
    
    if(isReplyV == TypeShuoshuo){
        
        [self.attributedDataShuoshuo removeAllObjects];
        //**********号码******
        
        NSMutableArray *mobileLink = [RegularExpressionManager matchMobileLink:dataSourceString];
        for (int i = 0; i < mobileLink.count; i ++) {
            
            [self.attributedDataShuoshuo addObject:[mobileLink objectAtIndex:i]];
        }
        
        //*************************
        
        
        //***********匹配网址*********
        
        NSMutableArray *webLink = [RegularExpressionManager matchWebLink:dataSourceString];
        for (int i = 0; i < webLink.count; i ++) {
            
            [self.attributedDataShuoshuo addObject:[webLink objectAtIndex:i]];
        }
        
    }
    
    if (isReplyV == TypeFavour) {
        
        [self.attributedDataFavour removeAllObjects];
        int originX = 0;
        for (int i = 0; i < (_favourArray.count>2?3:_favourArray.count); i ++) {
            NSString *text = [_favourArray objectAtIndex:i];
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:text,NSStringFromRange(NSMakeRange(originX, text.length)), nil];
            [self.attributedDataFavour addObject:dic];
            originX += (1 + text.length);
        }
    }
}


// 收藏区域高度
- (float)calculateFavourHeightWithWidth:(float)sizeWidth{
    
    typeview = TypeFavour;
    float height = .0f;
    
    NSString *matchString;
   if (_favourArray.count<3) {
  
        matchString =[_favourArray componentsJoinedByString:@","];
    
    }else{
        NSLog(@"%@",_favourArray);
        
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        for (int i=0; i<3; i++) {
            [tempArr addObject:_favourArray[i]];
        }
        NSLog(@"11--------%@",tempArr);
//        [_favourArray removeAllObjects];
//        _favourArray = tempArr;
        NSString *tempStr=[tempArr componentsJoinedByString:@","];
        matchString =[NSString stringWithFormat:@"%@等%li人已收藏",tempStr,_favourArray.count];
    }
    

    _showFavour = matchString;
    NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    //存新的
    self.completionFavour = newString;
    
    [self matchString:newString fromView:typeview];
    
    ICTextView *_icCoreText = [[ICTextView alloc] initWithFrame:CGRectMake(offSet_X + 30,10, sizeWidth - 2*offSet_X - 30, 0)];
    
    _icCoreText.isFold = NO;
    _icCoreText.isDraw = NO;
    
    [_icCoreText setOldString:_showFavour andNewString:newString];
    
    return [_icCoreText getTextHeight];
    
    return height;
}

//计算replyview高度
- (float) calculateReplyHeightWithWidth:(float)sizeWidth{
    
    typeview = TypeReply;
    float height = .0f;
    
    for (int i = 0; i < self.replyDataSource.count; i ++ ) {
        
        tempInt = i;
        
        ICReplyBody *body = (ICReplyBody *)[self.replyDataSource objectAtIndex:i];
        
        NSString *matchString;
        
        if ([body.repliedUser isEqualToString:@""]) {
            matchString = [NSString stringWithFormat:@"%@:%@",body.replyUser,body.replyInfo];
            
        }else{
            matchString = [NSString stringWithFormat:@"%@回复%@:%@",body.replyUser,body.repliedUser,body.replyInfo];
            
        }
        NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
        
        NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                           withString:PlaceHolder];
        //存新的
        [self.completionReplySource addObject:newString];
        
        [self matchString:newString fromView:typeview];
        
        ICTextView *_ilcoreText = [[ICTextView alloc] initWithFrame:CGRectMake(offSet_X,10, sizeWidth - offSet_X * 2, 0)];
        
        _ilcoreText.isFold = NO;
        _ilcoreText.isDraw = NO;
        
        [_ilcoreText setOldString:matchString andNewString:newString];
        
        height =  height + [_ilcoreText getTextHeight] ;
        
    }
    
    [self calculateShowImageHeight];
    
    return height;
    
}
//图片高度
- (void)calculateShowImageHeight{
    
    if (self.showImageArray.count == 0) {
        self.showImageHeight = 0;
    }else{
        self.showImageHeight = (ShowImage_H + 10) * ((self.showImageArray.count - 1)/3 + 1);
    }
    
}

//说说高度
- (float) calculateShuoshuoHeightWithWidth:(float)sizeWidth withUnFoldState:(BOOL)isUnfold{
    
    typeview = TypeShuoshuo;
    
    NSString *matchString =  _showShuoShuo;
    
    NSArray *itemIndexs = [RegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:matchString];
    
    //用PlaceHolder 替换掉[em:02:]这些
    NSString *newString = [matchString replaceCharactersAtIndexes:itemIndexs
                                                       withString:PlaceHolder];
    //存新的
    self.completionShuoshuo = newString;
    
    [self matchString:newString fromView:typeview];
    
    ICTextView *_icCoreText = [[ICTextView alloc] initWithFrame:CGRectMake(20,10, sizeWidth - 2*20, 0)];
    
    _icCoreText.isDraw = NO;
    
    [_icCoreText setOldString:_showShuoShuo andNewString:newString];
    
    if ([_icCoreText getTextLines] <= limitline) {
        self.islessLimit = YES;
    }else{
        self.islessLimit = NO;
    }
    
    if (!isUnfold) {
        _icCoreText.isFold = YES;
        
    }else{
        _icCoreText.isFold = NO;
    }
    return [_icCoreText getTextHeight];
    
}
@end
