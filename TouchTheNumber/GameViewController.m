//
//  GameViewController.m
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/07/27.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _moveFlg = YES;
    _nextNum = 1;
    
    _btnAry = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
               @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
               @"21", @"22", @"23", @"24", @"25", nil];
    
    for (int i = [_btnAry count] - 1; i >= 0; i--) {
        int j = rand() % (i+1);
        [_btnAry exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    _btnContainerAry = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [_btnAry count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [self getBtnRect:i];
        [btn setTitle:_btnAry[i - 1] forState:UIControlStateNormal];
        btn.tag = [_btnAry[i - 1] intValue];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(pressedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [_btnContainerAry addObject:btn];
    }
    
    [self countUp];
    [self moveStart];
}

- (CGRect)getBtnRect:(NSInteger)i
{
    int tmp = (i - 1) % 5;
    int tmp2 = (i - 1) / 5;
    return CGRectMake(10.0f + tmp * 60, 70.0f + 60.0f * tmp2, 60.0f, 60.0f);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressedBtn:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == _nextNum) {
        [self btnRotation:btn];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _nextNum++;
        if (_nextNum == 26) {
            [_timer invalidate];
            [_moveTimer invalidate];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:_timerLabel.text forKey:@"SCORE"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        _nextNumLabel.text = [NSString stringWithFormat:@"%d", _nextNum];
            
    }
}

- (void)btnRotation:(UIButton *)button
{
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI * 120.0f / 180.0f), CGAffineTransformMakeScale(6.0f, 6.0f));
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              button.transform = CGAffineTransformMakeRotation(M_PI * 240.0f / 180.0f);
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.1f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveLinear
                                                               animations:^{
                                                                    button.transform = CGAffineTransformMakeRotation(M_PI * 360.0f / 180.0f);
                                                                   
                                                               }
                                                               completion:^(BOOL finished){
                                                                   button.transform = CGAffineTransformIdentity;
                                                               }];
                                            
                                        }];
                    }];
}

- (void)countUp
{
   _timer = [NSTimer scheduledTimerWithTimeInterval:(0.001f)
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil
                                            repeats:YES];
    _stdate = [[NSDate alloc] init];
}

- (void)onTimer:(NSTimer*)timer {
    _now = [NSDate date];
    _timerLabel.text = [NSString stringWithFormat:@"%.3f", [_now timeIntervalSinceDate:_stdate]];
}

- (void)moveStart
{
    _moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                                  target:self
                                                selector:@selector(moveBtn:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)moveBtn:(NSTimer*)timer
{
    if (_moveFlg) {
        NSArray *ary = [self getRandBtnIndexes];
        [self moveFrom:[ary[0] intValue] to:[ary[1] intValue]];
    }
    _moveFlg = !_moveFlg;
    
    [self btnRotation:([_btnContainerAry objectAtIndex:rand() % _btnContainerAry.count])];
}

- (NSArray *)getRandBtnIndexes
{
    NSInteger firstBtnIndex = rand() % _btnContainerAry.count;
    NSInteger secondBtnIndex = [self getSecondBtnIndex:firstBtnIndex + 1];
    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", firstBtnIndex],
                                            [NSString stringWithFormat:@"%d", secondBtnIndex - 1], nil];
}

- (NSInteger)getSecondBtnIndex:(NSInteger)index
{
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    if (index < 21)
        [ary addObject:[NSString stringWithFormat:@"%d", index + 5]];
    if (index > 5)
        [ary addObject:[NSString stringWithFormat:@"%d", index - 5]];
    if (index % 5)
        [ary addObject:[NSString stringWithFormat:@"%d", index + 1]];
    if (index % 5 != 1)
        [ary addObject:[NSString stringWithFormat:@"%d", index - 1]];
    
    return [ary[rand() % ary.count] intValue];
}

- (void)moveFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    CGRect toFrame = [[_btnContainerAry objectAtIndex:toIndex] frame];
    CGRect fromFrame = [[_btnContainerAry objectAtIndex:fromIndex] frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [[_btnContainerAry objectAtIndex:fromIndex] setFrame:toFrame];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [[_btnContainerAry objectAtIndex:toIndex] setFrame:fromFrame];
    [UIView commitAnimations];
    
    [_btnContainerAry exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

- (IBAction)backToTitle:(id)sender
{
    [_timer invalidate];
    [_moveTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
