//
//  StudentHomeworkDeadlinesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/20/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "StudentHomeworkDeadlinesCDTVC.h"
#import "LoginNotification.h"
#import "Homework.h"
#import "DisplayHomeworkViewController.h"

@implementation StudentHomeworkDeadlinesCDTVC

// Makes the view controller listen when a student has logged in
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:STUDENT_LOGIN_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.student = note.userInfo[STUDENT_LOGIN_CONTEXT];
                                                  }];
}

// Initializes fetched results controller when view is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeFetchResultsController];
}

// Initializes the NSFetchedResultsController to the following request
- (void)initializeFetchResultsController
{ 
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Homework"];
    request.predicate = [NSPredicate predicateWithFormat:@"inClass.student = %@", self.student];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates a fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[self.student managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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


// Changes status of homework when tapped
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
    homework.completed = [NSNumber numberWithBool:!homework.completed.boolValue];
    return NO;
}



@end
