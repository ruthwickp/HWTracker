//
//  StudentAddSubjectViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/14/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "StudentAddSubjectViewController.h"
#import "Teacher.h"
#import "Subject+Create.h"
#import "NSManagedObject+Clone.h"

@interface StudentAddSubjectViewController ()
@property (nonatomic, strong) Subject *chosenSubject;
@end

@implementation StudentAddSubjectViewController

#pragma mark - NSFetchedResultsController

// Loads the bar button items and initializes NSFetchedResultsController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeFetchResultsController];
}

// Removes modal view controller when cancel is pressed
- (IBAction)cancelButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Initializes the NSFetchedResultsController to the following request
- (void)initializeFetchResultsController
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"teacher.fromSchool = %@", self.student.fromSchool];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teacher.name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates a fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[self.student managedObjectContext]
                                                                          sectionNameKeyPath:@"teacher.name"
                                                                                   cacheName:nil];
}

#pragma mark - Tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Teacher Class Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = subject.name;
    cell.detailTextLabel.text = subject.teacher.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    else {
        return nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

// Stores the chosen class for the student
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenSubject = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Navigation

#define UNWIND_SEGUE_IDENTIFIER @"Finished Adding Class"

// When we segue, we make the student have the subject in core data
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        // Creates an instance of the subject for the student
        if (self.chosenSubject) {
            Subject *newSubject = (Subject *)[self.chosenSubject clone];
            newSubject.student = self.student;
        }
    }
}

// Makes sure the student chose a class before we can segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // If a chosen subject has been chosen we can unwind, else
    // we inform the user
    if ([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        if (self.chosenSubject) {
            return YES;
        }
        else {
            [self alert:@"Must choose a class to add"];
            return NO;
        }
    }
    else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

// Shows an alert view containing the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Adding Class"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}


@end
