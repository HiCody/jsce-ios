//
//  MMRecordView.m
//  jsce
//
//  Created by mac on 15/10/16.
//  Copyright © 2015年 Yuantu. All rights reserved.
//

#import "MMRecordView.h"
#import "EMCDDeviceManager.h"
@interface MMRecordView ()
{
    NSTimer *_timer;
    // 显示动画的ImageView
    UIImageView *_recordAnimationView;
    UIImageView *_microPhoneImageView;
    UIImageView *_cancelRecordImageView;
    // 提示文字
    UILabel *_textLabel;
}

@end
@implementation MMRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
       _microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27.0, 8, 40.0, 99)];
        _microPhoneImageView.image = [UIImage imageNamed:@"RecordingBkg"];
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(82.0, 34.0, 18.0, 61.0)];
        _recordAnimationView.image = [UIImage imageNamed:@"RecordingSignal001"];
        _cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19.0, 7.0, 100.0, 100.0)];
        _cancelRecordImageView.image = [UIImage imageNamed:@"RecordCancel"];
        _cancelRecordImageView.hidden = YES;

        
        [self addSubview:_recordAnimationView];
         [self addSubview:_microPhoneImageView];
        [self addSubview:_cancelRecordImageView];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                               self.bounds.size.height - 30,
                                                               self.bounds.size.width - 10,
                                                               25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @"手指上划，取消发送";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return  self;
    
}

// 录音按钮按下
-(void)recordButtonTouchDown
{
    // 需要根据声音大小切换recordView动画
    _textLabel.text = @"手指上划，取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
    _cancelRecordImageView.hidden = YES;
    _recordAnimationView.hidden=NO;
    _microPhoneImageView.hidden=NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}
// 手指在录音按钮内部时离开
-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}
// 手指在录音按钮外部时离开
-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}
// 手指移动到录音按钮内部
-(void)recordButtonDragInside
{
    _cancelRecordImageView.hidden = YES;
    _recordAnimationView.hidden=NO;
    _microPhoneImageView.hidden=NO;
    _textLabel.text = @"松开手指，取消发送";
    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
-(void)recordButtonDragOutside
{
    _cancelRecordImageView.hidden=NO;
    _recordAnimationView.hidden=YES;
    _microPhoneImageView.hidden=YES;
    _textLabel.text = @"松开手指，取消发送";
    _textLabel.backgroundColor = [UIColor redColor];
}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:@"RecordingSignal001"];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    if (0 < voiceSound <= 0.1) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal001"]];
    }else if (0.1<voiceSound<=0.2) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal001"]];
    }else if (0.2<voiceSound<=0.3) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal002"]];
    }else if (0.3<voiceSound<=0.4) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal003"]];
    }else if (0.4<voiceSound<=0.5) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal004"]];
    }else if (0.5<voiceSound<=0.6) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal005"]];
    }else if (0.7<voiceSound<=0.8) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal006"]];
    }else if (0.8<voiceSound<=0.9) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal007"]];
    }else if (0.9<voiceSound<=1.0) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"RecordingSignal008"]];
    }
}



@end
