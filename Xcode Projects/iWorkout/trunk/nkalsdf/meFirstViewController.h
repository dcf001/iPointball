//
//  meFirstViewController.h
//  nkalsdf
//
//  Created by Ryan Frahm on 8/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface meFirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *todaysDate;
@property(nonatomic,retain)NSMutableDictionary *daysOfWeek;
@property(nonatomic,retain)NSArray *datasource;
-(void)setupArray;

@end
