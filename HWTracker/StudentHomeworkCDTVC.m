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
#import "ManagedObjectChangedNotification.h"

@implementation StudentHomeworkCDTVC

// Reloads table data when homework is added, deleted, or updated
#warning Haven't tested this out
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:ADDED_HOMEWORK_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableView reloadData];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:DELETED_HOMEWORK_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableView reloadData];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UPDATED_HOMEWORK_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableView reloadData];
                                                  }];
}


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
