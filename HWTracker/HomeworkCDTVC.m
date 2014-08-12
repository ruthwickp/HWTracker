//
//  HomeworkCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/12/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeworkCDTVC.h"
#import "Homework.h"


#import "Homework+Create.h"

@interface HomeworkCDTVC ()

@end

@implementation HomeworkCDTVC

#pragma mark - FetchedResultsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Homework createHomeworkWithTitle:@"FirstHomework"
                                 info:@"Pages: 10-12341234"
                              dueDate:[NSDate date]
                               status:[NSNumber numberWithBool:NO]
                              inClass:self.subject];
    [self initializeFetchResultsController];
}

// Initializes the NSFetchedResultsController to the following request
- (void)initializeFetchResultsController
{
    // Makes a request for the given entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Homework"];
    request.predicate = [NSPredicate predicateWithFormat:@"inClass = %@", self.subject];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate"
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    // Creates a fetchedResultsController
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[self.subject managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Homework";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure cell
    Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = homework.title;
    // Adds due date as subtitle
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due: %@", [dateFormatter stringFromDate:homework.dueDate]];
    // Colors cell according to completion status
    cell.backgroundColor = homework.completed.boolValue ? [UIColor greenColor] : [UIColor whiteColor];
    return cell;
}

// Changes status of homework when tapped
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    Homework *homework = [self.fetchedResultsController objectAtIndexPath:indexPath];
    homework.completed = [NSNumber numberWithBool:!homework.completed.boolValue];
    return NO;
}

@end
