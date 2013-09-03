//
//  HardViewController.h
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/08/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HardViewController : UIViewController {
    UILabel *_timerLabel;
	UILabel *_nextNumLabel;
    
    NSMutableArray      *_btnContainerAry;
    NSInteger           _nextNum;
    NSTimer             *_timer;
    BOOL                _timeFlg;
    NSDate              *_stDate;
    NSTimer             *_moveTimer;
    int					_disturbCnt;

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

@end
