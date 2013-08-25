//
//  TitleController.m
//  TouchTheNumber
//
//  Created by yusuke_yasuo on 2013/07/27.
//  Copyright (c) 2013年 kazuki_ijima. All rights reserved.
//

#import "TitleController.h"

@interface TitleController ()

@end

@implementation TitleController

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
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *score = [ud stringForKey:@"SCORE"];
    if (!score) {
        _scoreLabel.text = @"-";
    } else {
        _scoreLabel.text = score;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
