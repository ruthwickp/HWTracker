//
//  StudentClassesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "StudentClassesCDTVC.h"
#import "StudentAddSubjectViewController.h"
#import "Subject.h"
#import "StudentHomeworkCDTVC.h"

@interface StudentClassesCDTVC ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation StudentClassesCDTVC

#pragma mark - Displaying Classes

// Lazily instantiate the context using the student object
- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [self.student managedObjectContext];
    }
    return _context;
}

// Resets view controller when view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeFetchResultsController];
}

// Sets the fetched results controller
- (void)initializeFetchResultsController
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"student = %@", @[self.student]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

// When student deletes a class, we delete the subject
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete subject with the following information
        Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[self.fetchedResultsController managedObjectContext] deleteObject:subject];
    }
}

#pragma mark - Navigation

#define STUDENT_ADD_SUBJECT @"Student Add Subject"
#define CLASS_HOMEWORK @"Class Homework"

// Modally segues when button is pressed
- (void)addButtonPressed
{
    [self performSegueWithIdentifier:STUDENT_ADD_SUBJECT sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Modally segues to the view controller for adding subject
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *destinationVC = segue.destinationViewController;
        if ([destinationVC.viewControllers[0] isKindOfClass:[StudentAddSubjectViewController class]]) {
            // Passes on student to the navigation controllers first controller
            if ([segue.identifier isEqualToString:STUDENT_ADD_SUBJECT]) {
                StudentAddSubjectViewController *studentASVC = destinationVC.viewControllers[0];
                studentASVC.student = self.student;
            }
        }
    }
    // Segues to display assignments for a given class
    else if ([segue.destinationViewController isKindOfClass:[StudentHomeworkCDTVC class]]) {
        if ([segue.identifier isEqualToString:CLASS_HOMEWORK]) {
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                StudentHomeworkCDTVC *studentHCDTVC = segue.destinationViewController;
                Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
                studentHCDTVC.title = subject ? subject.name : nil;
                studentHCDTVC.subject = subject ? subject : nil;
            }
        }
    }
}

// Unwind segue action
- (IBAction)studentDoneClicked:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[StudentAddSubjectViewController class]]) {
        NSLog(@"Did click on done, student added subject");
    }
}


@end
