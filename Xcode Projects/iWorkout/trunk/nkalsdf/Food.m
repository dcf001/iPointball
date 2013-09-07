//
//  Food.m
//  nkalsdf
//
//  Created by Ryan Frahm on 9/7/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "Food.h"

@implementation Food
@synthesize category,name;

+(id)FoodOfCategory:(NSString *)category name:(NSString *)name
{
    Food *newFood = [[Food alloc]init];
    newFood.category = category;
    newFood.name = name;
    return newFood;
}

@end
