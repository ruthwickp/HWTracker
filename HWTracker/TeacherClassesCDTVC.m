//
//  TeacherClassesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherClassesCDTVC.h"
#import "TeacherAddSubjectViewController.h"
#import "TeacherHomeworkCDTVC.h"

@interface TeacherClassesCDTVC ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation TeacherClassesCDTVC

#pragma mark - Displaying Classes

// Lazily instantiate the context using the teacher object
- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [self.teacher managedObjectContext];
    }
    return _context;
}

// Resets view controller when view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetFetchResultsController];
}

// Sets the fetched results controller
- (void)resetFetchResultsController
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"teacher = %@", self.teacher];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Navigation

#define TEACHER_ADD_SUBJECT @"Teacher Add Subject"
#define CLASS_HOMEWORK @"Class Homework"

// Modally segues when button is pressed
- (void)addButtonPressed
{
    [self performSegueWithIdentifier:TEACHER_ADD_SUBJECT sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Modally segues to the view controller for adding subject
    if ([segue.destinationViewController isKindOfClass:[TeacherAddSubjectViewController class]]) {
        if ([segue.identifier isEqualToString:TEACHER_ADD_SUBJECT]) {
            TeacherAddSubjectViewController *teacherASVC = segue.destinationViewController;
            teacherASVC.teacher = self.teacher;
        }
    }
    // Segues to display assignments for a given class
    else if ([segue.destinationViewController isKindOfClass:[TeacherHomeworkCDTVC class]]) {
        if ([segue.identifier isEqualToString:CLASS_HOMEWORK]) {
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                TeacherHomeworkCDTVC *teacherHCDTVC = segue.destinationViewController;
                Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
                teacherHCDTVC.title = subject ? subject.name : nil;
                teacherHCDTVC.subject = subject ? subject : nil;
            }
        }
    }
}

// Saves context when we added a subject
- (IBAction)doneClicked:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[TeacherAddSubjectViewController class]]) {
        NSLog(@"Did click on done");
    }
}

@end
