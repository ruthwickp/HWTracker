//
//  TeacherHomeworkCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/12/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherHomeworkCDTVC.h"
#import "AddHomeworkViewController.h"
#import "TeacherDisplayHomeworkViewController.h"
#import "Homework.h"

@interface TeacherHomeworkCDTVC ()

@end

@implementation TeacherHomeworkCDTVC

#pragma mark - Editing

// Displays edit button on the right hand side of view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// When editing, removes back button and creates an add button
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(createHomework)];
        self.navigationItem.leftBarButtonItem = addButton;
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

// Allows homeworks to be deleted from class
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[self.fetchedResultsController managedObjectContext] deleteObject:homework];
    }
}

#pragma mark - Navigation

#define CREATE_HOMEWORK @"Create Homework"

// Modally segues to another view controller to create
// the homework
- (void)createHomework
{
    [self performSegueWithIdentifier:CREATE_HOMEWORK sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segues to create homework
    if ([segue.destinationViewController isKindOfClass:[AddHomeworkViewController class]]) {
        if ([segue.identifier isEqualToString:CREATE_HOMEWORK]) {
            AddHomeworkViewController *addHomeworkVC = segue.destinationViewController;
            addHomeworkVC.subject = self.subject;
        }
    }
    // Segues to display homework
    else if ([segue.destinationViewController isKindOfClass:[TeacherDisplayHomeworkViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
            TeacherDisplayHomeworkViewController *teacherDisplayHVC = segue.destinationViewController;
            teacherDisplayHVC.homework = [self.fetchedResultsController objectAtIndexPath:indexpath];
        }
    }
}

// Unwind segue
- (IBAction)createdHomework:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[AddHomeworkViewController class]]) {
        NSLog(@"Done clicked. Added Homework");
    }
}


@end
