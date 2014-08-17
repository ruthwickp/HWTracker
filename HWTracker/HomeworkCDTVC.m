//
//  HomeworkCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/12/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeworkCDTVC.h"
#import "Homework.h"

@implementation HomeworkCDTVC

#pragma mark - FetchedResultsController

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
    request.predicate = [NSPredicate predicateWithFormat:@"inClass = %@", self.subject];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dueDate"
                                                              ascending:NO],
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

// Removes highlighting for cell
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
