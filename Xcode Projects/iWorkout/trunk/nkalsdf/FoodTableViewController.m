//
//  FoodTableViewController.m
//  nkalsdf
//
//  Created by Ryan Frahm on 9/7/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "FoodTableViewController.h"
#import "Food.h"

@interface FoodTableViewController ()

@end

@implementation FoodTableViewController
@synthesize foodArray,foodSearchBar,filteredFoodArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    foodArray = [NSArray arrayWithObjects:
                 [Food FoodOfCategory:@"Protein" name:@"Chicken breast"],
                 [Food FoodOfCategory:@"Protein" name:@"Steak"],
                 [Food FoodOfCategory:@"Protein" name:@"Bacon"],
                 [Food FoodOfCategory:@"Veggie" name:@"Carrots"],
                 [Food FoodOfCategory:@"Veggie" name:@"Broccoli"],
                 [Food FoodOfCategory:@"Veggie" name:@"Spinach"],
                 [Food FoodOfCategory:@"Dairy" name:@"Milk"],
                 [Food FoodOfCategory:@"Dairy" name:@"Yogurt"],
                 [Food FoodOfCategory:@"Dairy" name:@"Cottage Cheese"], nil];
    self.filteredFoodArray = [NSMutableArray arrayWithCapacity:[foodArray count]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredFoodArray count];
    }else
    {
        return [foodArray count];
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Food *food = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        food = [filteredFoodArray objectAtIndex:indexPath.row];
    }
    else
    {
        food = [foodArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = food.name;
    return cell;
}

#pragma mark Filtered Content
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredFoodArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredFoodArray = [NSMutableArray arrayWithArray:[foodArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark UISearchDisplayController
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:
      [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"FoodDetail" sender:tableView];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"FoodDetail"])
    {
        UIViewController *foodDetailViewController = [segue destinationViewController];
        
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *destinationTitle = [[filteredFoodArray objectAtIndex:[indexPath row]]name];
            [foodDetailViewController setTitle:destinationTitle];
        }
        else
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSString *destinationTitle = [[foodArray objectAtIndex:[indexPath row]]name];
            [foodDetailViewController setTitle:destinationTitle];
        }
    }
}

@end
