//
//  meViewController.m
//  RacingTycoon
//
//  Created by Ryan Frahm on 11/28/12.
//  Copyright (c) 2012 Ryan Frahm. All rights reserved.
//

#import "meViewController.h"

@interface meViewController ()

@end

@implementation meViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GenderType:(UIButton *)sender {
    NSString *gender = sender.currentTitle;
    // Send gender to database
}
@end
