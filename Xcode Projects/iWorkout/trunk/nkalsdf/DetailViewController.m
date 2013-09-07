//
//  DetailViewController.m
//  nkalsdf
//
//  Created by Ryan Frahm on 9/6/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize dayOfWeek,bodyPart,lblBodyPart,lblDayOfWeek,date,lblDate;

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
    lblDayOfWeek.text = dayOfWeek;
    lblBodyPart.text = bodyPart;
    lblDate.text = date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
