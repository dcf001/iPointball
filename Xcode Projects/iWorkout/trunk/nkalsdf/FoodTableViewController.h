//
//  FoodTableViewController.h
//  nkalsdf
//
//  Created by Ryan Frahm on 9/7/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *foodSearchBar;
@property(nonatomic,strong)NSArray *foodArray;
@property(nonatomic,strong)NSMutableArray *filteredFoodArray;
@end
