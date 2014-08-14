//
//  TeacherHomeworkDeadlinesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/14/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherHomeworkDeadlinesCDTVC.h"
#import "TeacherDisplayHomeworkViewController.h"
#import "LoginNotification.h"

@interface TeacherHomeworkDeadlinesCDTVC ()

@end

@implementation TeacherHomeworkDeadlinesCDTVC

// Makes the view controller listen when a teacher has logged in
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:TEACHER_LOGIN_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.teacher = note.userInfo[TEACHER_LOGIN_CONTEXT];
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
    request.predicate = [NSPredicate predicateWithFormat:@"inClass.teacher = %@", self.teacher];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates a fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[self.teacher managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segues to display homework
    if ([segue.destinationViewController isKindOfClass:[TeacherDisplayHomeworkViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexpath = [self.tableView indexPathForCell:sender];
            TeacherDisplayHomeworkViewController *teacherDisplayHVC = segue.destinationViewController;
            teacherDisplayHVC.homework = [self.fetchedResultsController objectAtIndexPath:indexpath];
        }
    }
}



@end
