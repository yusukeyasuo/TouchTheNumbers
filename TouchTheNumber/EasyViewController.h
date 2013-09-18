//
//  EasyViewController.h
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/08/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyViewController : UIViewController
{
    IBOutlet UILabel    *_timerLabel;
    IBOutlet UILabel    *_nextNumLabel;
    
    NSTimer             *_timer;
    NSInteger           _nextNum;
    NSMutableArray      *_btnAry;
    NSMutableArray      *_btnContainerAry;
    NSDate              *_stdate;
    NSDate              *_now;
}

@end
