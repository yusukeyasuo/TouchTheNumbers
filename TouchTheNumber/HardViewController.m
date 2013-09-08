//
//  HardViewController.m
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/08/25.
//  Copyright (c) 2013年 yusuke_yasuo. All rights reserved.
//


#import "HardViewController.h"

@interface HardViewController ()

@end

@implementation HardViewController

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
    NSLog(@"井島君担当");
	printf("僕の担当で〜す\n");
	printf("Vamos!! 俺たちの枝にゃん\n");
	
// iOS7だと動きがおかしいっぽい
// (nextNoをタップしてもミスになる)
	
	_nextNum = 1;
	_disturbCnt = 0;
	
	//	_disturbImage = [UIImage imageNamed:@"star.PNG"];
	
	hitUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hit" ofType:@"wav"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)hitUrl, &hitBtnId);
	
	missUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"miss" ofType:@"wav"]];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)missUrl, &missBtnId);
	
	
	if (!_timerLabel) {
		_timerLabel = [[UILabel alloc] init];
		[_timerLabel setFrame:CGRectMake(220, 23, 93, 21)];
		[_timerLabel setText:@"0.000"];
		[_timerLabel setFont:[UIFont systemFontOfSize:17]];
		[_timerLabel setTextColor:[UIColor cyanColor]];
		[_timerLabel setTextAlignment:NSTextAlignmentRight];
		[self.view addSubview:_timerLabel];
	}
	
	if (!_nextNumLabel) {
		_nextNumLabel = [[UILabel alloc] init];
		[_nextNumLabel setFrame:CGRectMake(131, 22, 58, 24)];
		[_nextNumLabel setText:@"1"];
		[_nextNumLabel setFont:[UIFont systemFontOfSize:20]];
		[_nextNumLabel setTextColor:[UIColor cyanColor]];
		[_nextNumLabel setTextAlignment:NSTextAlignmentCenter];
		[self.view addSubview:_nextNumLabel];
	}
	
	UILabel *nextLbl = [[UILabel alloc] init];
	[nextLbl setFrame:CGRectMake(131, 2, 58, 20)];
	[nextLbl setText:@"next"];
	[nextLbl setFont:[UIFont systemFontOfSize:11]];
	[nextLbl setTextColor:[UIColor cyanColor]];
	[nextLbl setTextAlignment:NSTextAlignmentCenter];
	[self.view addSubview:nextLbl];
	
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[backBtn setFrame:CGRectMake(0, 20, 73, 24)];
	[backBtn setTitle:@"Back" forState:UIControlStateNormal];
	[backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[backBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backToTitle:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backBtn];
	
	
	//	if (!_btnView) {
	//		_btnView = [[UIView alloc] init];
	//		[_btnView setFrame:CGRectMake(0, 30, 60 * 5, 60 * 5)];
	//		[self.view addSubview:_btnView];
	//	}
	
	
	NSMutableArray *btnAry = [[NSMutableArray alloc] initWithObjects:nil];
	
	for (int arrCnt = 0; arrCnt < 25; arrCnt++) {
		[btnAry addObject:[NSString stringWithFormat:@"%d", arrCnt + 1]];
	}
	
	int swapNum = 0;
	for (int arrCnt = 0; arrCnt < [btnAry count]; arrCnt++) {
        swapNum = rand() % (arrCnt + 1);
        [btnAry exchangeObjectAtIndex:arrCnt withObjectAtIndex:swapNum];
    }
	
	_btnContainerAry = [[NSMutableArray alloc] initWithObjects:nil];
	for (int arrCnt = 0; arrCnt < [btnAry count]; arrCnt++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(10.0f + (arrCnt % 5) * 60, 70 + (arrCnt / 5) * 60, 60, 60)];
        [btn setTitle:btnAry[arrCnt] forState:UIControlStateNormal];
        [btn setTag:[btnAry[arrCnt] intValue]];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchedBtn:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
		//        [_btnView addSubview:btn];
        [_btnContainerAry addObject:btn];
    }
	
	//	for (int numCnt = 0; numCnt < 25; numCnt++) {
	//		printf("%02d\n", [[btnAry objectAtIndex:numCnt] integerValue]);
	//		printf("%02d\n", [[_btnContainerAry objectAtIndex:numCnt] tag]);
	//	}
	
	_progressDate = [NSDate date];
	if (!_progressView) {
		_progressView = [[UIProgressView alloc] init];
		[_progressView setFrame:CGRectMake(30, 70, 260, 9)];
		[self.view addSubview:_progressView];
	}
	
	_timer = [NSTimer scheduledTimerWithTimeInterval:(0.001f) target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	//    _stdate = [[NSDate alloc] init];
	_stDate = [NSDate date];
	
	_moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(onMoveTimer:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	
}

-(IBAction)backToTitle:(UIButton *)sender {
	AudioServicesPlaySystemSound(missBtnId);
	if ([_timer isValid]) {
		[_timer invalidate];
	}
	if ([_moveTimer isValid]) {
		[_moveTimer invalidate];
	}
	
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 -(void) countUp {
 
 }
 */


-(void)onTimer:(NSTimer *)timer {
    _timerLabel.text = [NSString stringWithFormat:@"%0.3f", [[NSDate date] timeIntervalSinceDate:_stDate]];
	
	
	//	float progress = [[NSDate date] timeIntervalSinceDate:_progressDate];
	_progressView.progress = ([[NSDate date] timeIntervalSinceDate:_progressDate] / 3);
	
}

/*
 -(void)moveStart {
 }
 */

-(void) onMoveTimer:(NSTimer *)timer {
	_disturbCnt++;
	if (_disturbCnt > 1023) {
		_disturbCnt = 0;
	}
	
	// 移動
	if (_disturbCnt % 2 == 0) {
        NSArray *ary = [self getRandBtnIndexes];
        [self moveFrom:[ary[0] intValue] to:[ary[1] intValue]];
    }

	// 拡大・回転
    [self btnRotation:([_btnContainerAry objectAtIndex:rand() % _btnContainerAry.count])];

	// view移動
	//	NSLog(@"%f", cos(M_PI * (double)(_disturbCnt % 8) / 8));
	//
	//	[UIView beginAnimations:Nil context:Nil];
	//	[UIView setAnimationBeginsFromCurrentState:0.3f];
	//
	//	[_btnView setFrame:CGRectMake(0, 10 + cos(M_PI * (double)(_disturbCnt % 8) / 8) * 30, 60 * 5, 60 + 5)];
	//
	//	[UIView commitAnimations];
	
	// 邪魔イメージ
	/*
	 if (_disturbCnt % 4 == 0) {
	 int x;
	 int y;
	 
	 x = rand() % 200;
	 y = rand() % 200;
	 
	 if (x % 2 == 0) {
	 x = x - 200;
	 }
	 else {
	 x = x + 320;
	 }
	 
	 if (y % 2 == 0) {
	 y = y - 200;
	 }
	 else {
	 y = y + 548;
	 }
	 
	 UIImageView *disturbImageView = [[UIImageView alloc] init];
	 [disturbImageView setFrame:CGRectMake(x, y, 128, 128)];
	 [disturbImageView setImage:_disturbImage];
	 [self.view addSubview:disturbImageView];
	 
	 [UIView beginAnimations:Nil context:Nil];
	 [UIView setAnimationBeginsFromCurrentState:0.3f];
	 
	 x = rand() % 200;
	 y = rand() % 200;
	 
	 if (x % 2 == 0) {
	 x = x - 200;
	 }
	 else {
	 x = x + 320;
	 }
	 
	 if (y % 2 == 0) {
	 y = y - 200;
	 }
	 else {
	 y = y + 548;
	 }
	 
	 [disturbImageView setFrame:CGRectMake(x, y, 128, 128)];
	 
	 [UIView commitAnimations];
	 }
	 */
	
	// 時間制限
	if (_progressView.progress == 1) {
		[self missPenalty];
	}
}

-(NSArray *)getRandBtnIndexes {
	NSInteger firstBtnIndex = rand() % _btnContainerAry.count;
    NSInteger secondBtnIndex = [self getSecondBtnIndex:firstBtnIndex + 1];
    return [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d", firstBtnIndex], [NSString stringWithFormat:@"%d", secondBtnIndex - 1], nil];
}

-(NSInteger)getSecondBtnIndex:(NSInteger)index {
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

- (void)moveFrom:(NSInteger)fromIndex to:(NSInteger)toIndex {
    CGRect toFrame = [[_btnContainerAry objectAtIndex:toIndex] frame];
    CGRect fromFrame = [[_btnContainerAry objectAtIndex:fromIndex] frame];
/*
	CGRect toFrameVib;
	CGRect fromFrameVib;
	
    float elapsedTime = 0;
	float vibTime = 0.3;
	float vibWidth = 30;
	
//	for (int repeatCnt = 0; repeatCnt < 3; repeatCnt++) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:vibTime];
		[UIView setAnimationDelay:elapsedTime];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		toFrameVib = toFrame;
		fromFrameVib = fromFrame;
		toFrameVib.origin.x = toFrameVib.origin.x - vibWidth;
		fromFrameVib.origin.x = fromFrameVib.origin.x - vibWidth;
		[[_btnContainerAry objectAtIndex:fromIndex] setFrame:fromFrameVib];
		[[_btnContainerAry objectAtIndex:toIndex] setFrame:toFrameVib];
		[UIView commitAnimations];
		elapsedTime = elapsedTime + vibTime;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:vibTime];
		[UIView setAnimationDelay:elapsedTime];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		toFrameVib = toFrame;
		fromFrameVib = fromFrame;
		toFrameVib.origin.x = toFrameVib.origin.x + vibWidth;
		fromFrameVib.origin.x = fromFrameVib.origin.x + vibWidth;
		[[_btnContainerAry objectAtIndex:fromIndex] setFrame:fromFrameVib];
		[[_btnContainerAry objectAtIndex:toIndex] setFrame:toFrameVib];
		[UIView commitAnimations];
		elapsedTime = elapsedTime + vibTime;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:vibTime];
		[UIView setAnimationDelay:elapsedTime];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		toFrameVib = toFrame;
		fromFrameVib = fromFrame;
		[[_btnContainerAry objectAtIndex:fromIndex] setFrame:fromFrameVib];
		[[_btnContainerAry objectAtIndex:toIndex] setFrame:toFrameVib];
		[UIView commitAnimations];
		elapsedTime = elapsedTime + vibTime;
//	}
*/
	
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
//	[UIView setAnimationDelay:elapsedTime];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [[_btnContainerAry objectAtIndex:fromIndex] setFrame:toFrame];
    [[_btnContainerAry objectAtIndex:toIndex] setFrame:fromFrame];
    [UIView commitAnimations];
    
    [_btnContainerAry exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

-(void)btnRotation:(UIButton *)button {
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

-(IBAction) touchedBtn:(UIButton *) sender {

    UIButton *btn = sender;
	_progressDate = [NSDate date];

	NSLog(@"tag %d : nextNum %d", sender.tag, _nextNum);

    if (btn.tag == _nextNum) {
		AudioServicesPlaySystemSound(hitBtnId);

        [self btnRotation:btn];
//        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[btn setAlpha:0.4];
		
        _nextNum++;
        if (_nextNum >= 26) {
            [_timer invalidate];
            [_moveTimer invalidate];
            [[NSUserDefaults standardUserDefaults] setObject:_timerLabel.text forKey:@"SCORE_HARD"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        _nextNumLabel.text = [NSString stringWithFormat:@"%d", _nextNum];
    }
	else {
		[self missPenalty];
	}
}

-(void) missPenalty {
	if (_nextNum > 1) {
		AudioServicesPlaySystemSound(missBtnId);

		_progressDate = [NSDate date];

		_nextNum--;
		_nextNumLabel.text = [NSString stringWithFormat:@"%d", _nextNum];

		for (int btnCnt = 0; btnCnt < 25; btnCnt++) {
			if ([[_btnContainerAry objectAtIndex:btnCnt] tag] == _nextNum) {
//				[[_btnContainerAry objectAtIndex:btnCnt] setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
				[[_btnContainerAry objectAtIndex:btnCnt] setAlpha:1];

			}
		}
	}
}

@end
