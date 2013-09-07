//
//  DetailViewController.h
//  nkalsdf
//
//  Created by Ryan Frahm on 9/6/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    NSString *dayOfWeek;
    NSString *bodyPart;
    NSString *date;
    IBOutlet UILabel *lblDayOfWeek;
    IBOutlet UILabel *lblBodyPart;
    IBOutlet UILabel *lblDate;
}
@property(nonatomic,retain)NSString *dayOfWeek,*bodyPart,*date;
@property(nonatomic,retain)IBOutlet UILabel *lblDayOfWeek,*lblBodyPart,*lblDate;
@end
