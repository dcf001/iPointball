//
//  meSecondViewController.h
//  nkalsdf
//
//  Created by Ryan Frahm on 8/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface meSecondViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelCalories;
@property (weak, nonatomic) IBOutlet UILabel *labelProtein;
@property (weak, nonatomic) IBOutlet UILabel *labelFat;
@property (copy, nonatomic) NSString *weight;
- (IBAction)changeLabels:(id)sender;
- (IBAction)textChanged;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Segment;
@end
