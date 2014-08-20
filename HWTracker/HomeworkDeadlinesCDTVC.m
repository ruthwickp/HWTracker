//
//  HomeworkDeadlinesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeworkDeadlinesCDTVC.h"
#import "Homework.h"

@interface HomeworkDeadlinesCDTVC ()

@end

@implementation HomeworkDeadlinesCDTVC

// Remove editing options
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"Upcoming Homework";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = homework.title;
    // Adds due date as subtitle
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due: %@", [dateFormatter stringFromDate:homework.dueDate]];
    // Colors cell according to completion status
    cell.backgroundColor = homework.completed.boolValue ? [UIColor greenColor] : [UIColor whiteColor];
    return cell;
}

// Removes highlighting capability
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



@end
