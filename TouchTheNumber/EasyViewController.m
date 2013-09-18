//
//  EasyViewController.m
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/08/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//

#import "EasyViewController.h"

@interface EasyViewController ()

@end

@implementation EasyViewController

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

}

- (CGRect)getBtnRect:(NSInteger)i
{
    int tmp = (i - 1) % 5;
    int tmp2 = (i - 1) / 5;
    return CGRectMake(10.0f + tmp * 60, 70.0f + 60.0f * tmp2, 60.0f, 60.0f);
}

- (void)pressedBtn:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == _nextNum) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _nextNum++;
        if (_nextNum == 26) {
            [_timer invalidate];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:_timerLabel.text forKey:@"SCORE"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        _nextNumLabel.text = [NSString stringWithFormat:@"%d", _nextNum];
        
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToTitle:(id)sender
{
    [_timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
