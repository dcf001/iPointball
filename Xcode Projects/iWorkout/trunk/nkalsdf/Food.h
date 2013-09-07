//
//  Food.h
//  nkalsdf
//
//  Created by Ryan Frahm on 9/7/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject
{
    NSString *category;
    NSString *name;
}
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *name;

+(id)FoodOfCategory:(NSString*)category name:(NSString*)name;

@end
