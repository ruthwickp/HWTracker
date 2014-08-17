//
//  StudentHomeworkCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "StudentHomeworkCDTVC.h"
#import "DisplayHomeworkViewController.h"
#import "Homework.h"

@implementation StudentHomeworkCDTVC

// Changes status of homework when tapped
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
    homework.completed = [NSNumber numberWithBool:!homework.completed.boolValue];
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segues to display homework
    if ([segue.destinationViewController isKindOfClass:[DisplayHomeworkViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
            DisplayHomeworkViewController *displayHVC = segue.destinationViewController;
            displayHVC.homework = [self.fetchedResultsController objectAtIndexPath:indexpath];
        }
    }
}


@end
