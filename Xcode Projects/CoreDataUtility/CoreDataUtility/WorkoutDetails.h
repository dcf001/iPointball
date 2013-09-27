//
//  WorkoutDetails.h
//  WorkoutSchedule
//
//  Created by Ryan Frahm on 9/8/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorkoutInfo;

@interface WorkoutDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) WorkoutInfo *info;

@end
