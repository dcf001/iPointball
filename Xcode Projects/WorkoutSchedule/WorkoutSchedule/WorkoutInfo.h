//
//  WorkoutInfo.h
//  WorkoutSchedule
//
//  Created by Ryan Frahm on 9/8/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutDetails;

@interface WorkoutInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) WorkoutDetails *details;

@end
