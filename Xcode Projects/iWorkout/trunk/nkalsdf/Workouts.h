//
//  Workouts.h
//  nkalsdf
//
//  Created by Ryan Frahm on 9/7/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Workouts : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * dayofweek;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSDate * date;

@end
