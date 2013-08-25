//
//  GameViewController.h
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/07/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
{
    IBOutlet UILabel    *_timerLabel;
    IBOutlet UILabel    *_nextNumLabel;
    
    NSMutableArray      *_btnAry;
    NSMutableArray      *_btnContainerAry;
    NSInteger           _nextNum;
    NSTimer             *_timer;
    BOOL                _timeflg;
    NSDate              *_stdate;
    NSDate              *_now;
    NSTimer             *_moveTimer;
    BOOL                _moveFlg;
}

- (IBAction)backToTitle:(id)sender;

@end
