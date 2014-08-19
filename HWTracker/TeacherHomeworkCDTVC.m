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
#import "NSManagedObject+Clone.h"

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
        // Posts a notification when a homework is going to be deleted
        Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self deleteAllHomeworkInstances:homework];
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
        // Updates all subjects to contain that homework
        AddHomeworkViewController *addHVC = segue.sourceViewController;
        if (addHVC.homework) {
            [self addAllHomeworkInstances:addHVC.homework];
            NSLog(@"Done clicked. Added Homework");
        }
    }
}

#pragma mark - Core Data Operations

// Deletes all homework instances that match the homework.
// Method is used to delete homeworks for each of the students
// taking the subject.
- (void)deleteAllHomeworkInstances:(Homework *)homework
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Homework"];
    request.predicate = [NSPredicate predicateWithFormat:@"(dueDate = %@) AND (info = %@) AND (title = %@) AND (inClass.name = %@) AND (inClass.teacher = %@)", homework.dueDate, homework.info, homework.title, homework.inClass.name, homework.inClass.teacher];
    
    // Finds matches from request
    NSError *error;
    NSArray *matches = [[homework managedObjectContext] executeFetchRequest:request error:&error];
    if (error || !matches) {
        NSLog(@"Error when trying to delete all instances of homework: %@", error);
    }
    else {
#warning Deleting Homework here may not work
        // Deletes all homework instances that match
        [matches enumerateObjectsWithOptions:NSEnumerationReverse
                                  usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                      if ([obj isKindOfClass:[NSManagedObject class]]) {
                                          [[homework managedObjectContext] deleteObject:obj];
                                      }
                                  }];
    }
}

// Adds all homework instances for every subject that matches the given
// homework. Method is used so that students can get homework updates
// that the teacher put newly.
- (void)addAllHomeworkInstances:(Homework *)homework
{
    // Gets all the subjects that match
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (teacher = %@)", self.subject.name, self.subject.teacher];
    
    // Finds matches from request
    NSError *error;
    NSArray *matches = [[homework managedObjectContext] executeFetchRequest:request error:&error];
    if (error || !matches) {
        NSLog(@"Error when trying to add homework for all subjects: %@", error);
    }
    else {
        [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Adds the homework to each subject
            if ([obj isKindOfClass:[Subject class]]) {
                Subject *eachSubject = (Subject *)obj;
                
                // Makes sure subject is not the current one since
                if (![eachSubject isEqual:self.subject]) {
                    Homework *addingHomework = (Homework *)[homework cloneInContext:[homework managedObjectContext]
                                                                     exludeEntities:@[@"Subject"]];
                    addingHomework.inClass = eachSubject;
                }
            }
        }];
    }
}

@end
