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
#import "Subject.h"
#import "ManagedObjectChangedNotification.h"
#import "LoginNotification.h"

@interface TeacherClassesCDTVC ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation TeacherClassesCDTVC

- (void)awakeFromNib
{
    // Makes the view controller listen when a teacher has logged in
    [[NSNotificationCenter defaultCenter] addObserverForName:TEACHER_LOGIN_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.teacher = note.userInfo[TEACHER_LOGIN_CONTEXT];
                                                      self.navigationItem.title = self.teacher.name;
                                                  }];
}

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
    request.predicate = [NSPredicate predicateWithFormat:@"(teacher = %@) AND (student = %@)", self.teacher, nil];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

// When a teacher deletes a subject, it gets
// deleted from core data and deletes all
// subject instances for the students
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Makes a request for all subject instances in core data
        // and removes them
        Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
        request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (teacher = %@)", subject.name, subject.teacher];
        
        // Finds matches from request
        NSError *error;
        NSArray *matches = [self.context executeFetchRequest:request error:&error];
        if (error || !matches) {
            NSLog(@"Error when deleting subject from teacher");
        }
        else {
            // Deletes all objects in core data
#warning Deleting class may not work here
            [matches enumerateObjectsWithOptions:NSEnumerationReverse
                                      usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                          if ([obj isKindOfClass:[NSManagedObject class]]) {
                                              [self.context deleteObject:obj];
                                          }
                                      }];
        }
        // Posts notification when subject is deleted
        [[NSNotificationCenter defaultCenter] postNotificationName:DELETED_SUBJECT_NOTIFICATION object:self];
    }
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
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDED_SUBJECT_NOTIFICATION object:self];
        NSLog(@"Did click on done for adding subject teacher");
    }
}

@end
