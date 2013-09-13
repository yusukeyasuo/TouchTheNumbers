//
//  HardViewController.h
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/08/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

// sound
//#import <AudioToolbox/AudioToolbox.h>

@interface HardViewController : UIViewController {
    UILabel *_timerLabel;
	UILabel *_nextNumLabel;
	
	//	UIView *_btnView;
    
    NSMutableArray      *_btnContainerAry;
    NSInteger           _nextNum;
    NSTimer             *_timer;
	//    BOOL                _timeFlg;
    NSDate              *_stDate;
    NSTimer             *_moveTimer;
    int					_disturbCnt;
	
	//	UIImage *_disturbImage;
	
	NSDate *_progressDate;
	UIProgressView *_progressView;
	
	// sound
//	SystemSoundID hitBtnId;
//	SystemSoundID missBtnId;
	NSURL *hitUrl;
	NSURL *missUrl;
}

-(IBAction) backToTitle:(UIButton *)sender;
//-(void) countUp;
-(void) onTimer:(NSTimer *)timer;
//-(void) moveStart;
-(void) onMoveTimer:(NSTimer *)timer;
-(NSArray *)getRandBtnIndexes;
-(NSInteger)getSecondBtnIndex:(NSInteger)index;
-(void)moveFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;
-(IBAction) touchedBtn:(UIButton *) sender;
-(void)btnRotation:(UIButton *)button;
-(void) missPenalty;

@end
