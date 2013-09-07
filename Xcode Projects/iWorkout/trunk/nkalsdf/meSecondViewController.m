//
//  meSecondViewController.m
//  nkalsdf
//
//  Created by Ryan Frahm on 8/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "meSecondViewController.h"

@interface meSecondViewController ()

@end

@implementation meSecondViewController
@synthesize weight = _weight;
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

- (IBAction)setBodyType{
    if(self.Segment.selectedSegmentIndex == 0)
    {
        
    }
    else if(self.Segment.selectedSegmentIndex == 1)
    {
        
    }
    else if(self.Segment.selectedSegmentIndex == 2)
    {
        
    }
}

- (IBAction)textChanged {
    self.weight = self.textCalories.text;
    int lbs = [self.weight intValue];
    NSString *cals,*prots,*fats;
    
    if(self.Segment.selectedSegmentIndex == 0)
    {
        cals = [NSString stringWithFormat:@"%d",lbs * 16];
        prots = [NSString stringWithFormat:@"%.f", lbs * 1.2];
    }
    else if(self.Segment.selectedSegmentIndex == 1)
    {
        cals = [NSString stringWithFormat:@"%d",lbs * 14];
        prots = [NSString stringWithFormat:@"%.f", lbs * 1.3];
    }
    else if(self.Segment.selectedSegmentIndex == 2)
    {
        cals = [NSString stringWithFormat:@"%d",lbs * 12];
        prots = [NSString stringWithFormat:@"%.f", lbs * 1.4];
    }
    if(lbs>=100 && lbs<150)
    {
        if (self.Segment.selectedSegmentIndex == 0)
        {
            fats = [NSString stringWithFormat:@"%d",45];
        }
        else if (self.Segment.selectedSegmentIndex == 1)
        {
            fats = [NSString stringWithFormat:@"%d",40];
        }
        else if (self.Segment.selectedSegmentIndex == 2)
        {
            fats = [NSString stringWithFormat:@"%d",50];
        }
    }
    else if(lbs>=150 && lbs<200)
    {
        if (self.Segment.selectedSegmentIndex == 0)
        {
            fats = [NSString stringWithFormat:@"%d",50];
        }
        else if (self.Segment.selectedSegmentIndex == 1)
        {
            fats = [NSString stringWithFormat:@"%d",45];
        }
        else if (self.Segment.selectedSegmentIndex == 2)
        {
            fats = [NSString stringWithFormat:@"%d",55];
        }
    }
    else if(lbs>200)
    {
        if (self.Segment.selectedSegmentIndex == 0)
        {
            fats = [NSString stringWithFormat:@"%d",55];
        }
        else if (self.Segment.selectedSegmentIndex == 1)
        {
            fats = [NSString stringWithFormat:@"%d",50];
        }
        else if (self.Segment.selectedSegmentIndex == 2)
        {
            fats = [NSString stringWithFormat:@"%d",60];
        }
    }
    NSLog(@"%d",self.Segment.selectedSegmentIndex);
    
    self.labelCalories.text = cals;
    self.labelProtein.text = prots;
    self.labelFat.text = fats;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textCalories) {
        [theTextField resignFirstResponder];
    }
    return YES;
}
@end
