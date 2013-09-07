//
//  meFirstViewController.m
//  nkalsdf
//
//  Created by Ryan Frahm on 8/27/13.
//  Copyright (c) 2013 Ryan Frahm. All rights reserved.
//

#import "meFirstViewController.h"

@interface meFirstViewController ()

@end

@implementation meFirstViewController
{
    NSArray *tableData;
}
@synthesize daysOfWeek,datasource;

- (void)viewDidLoad
{
    [self setupArray];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //tableData = [NSArray arrayWithObjects:@"Power Clean","Shoulder Press","Side Raises","Front Raises","Arnold Press", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupArray
{
    daysOfWeek = [[NSMutableDictionary alloc]init];
    [daysOfWeek setObject:@"Day Off" forKey:@"Monday"];
    [daysOfWeek setObject:@"Shoulders" forKey:@"Tuesday"];
    [daysOfWeek setObject:@"Legs" forKey:@"Wednesday"];
    [daysOfWeek setObject:@"Back" forKey:@"Thursday"];
    [daysOfWeek setObject:@"Day Off" forKey:@"Friday"];
    [daysOfWeek setObject:@"Chest" forKey:@"Saturday"];
    [daysOfWeek setObject:@"Day Off" forKey:@"Sunday"];
    
    datasource = [daysOfWeek allKeys];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [tableData count];
    return [datasource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //cell.textLabel.text = @"Detail";
    cell.textLabel.text = [datasource objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.dayOfWeek = [datasource objectAtIndex:indexPath.row];
    detail.bodyPart = [daysOfWeek objectForKey:detail.dayOfWeek];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM.dd.YY"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    self.todaysDate.text = dateString;
    NSLog(@"%@",dateString);
    detail.date = dateString;
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
