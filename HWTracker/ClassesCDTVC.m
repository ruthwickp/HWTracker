//
//  ClassesCDTVC.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ClassesCDTVC.h"
#import "Subject.h"

@interface ClassesCDTVC ()

@end

@implementation ClassesCDTVC

// Displays the add button to the view controller on the right
// and displays the edit button on the view controller to the
// left
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addButtonPressed)];
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
}

// Abstract method, must override
- (void)addButtonPressed
{}

// Allows deletion to be performed on the table view
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Removes object from database
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[self.fetchedResultsController managedObjectContext] deleteObject:object];
    }
}

// Displays subjects using the fetchedResultsController
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Class Subject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configures cell
    Subject *subject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = subject.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Assignments: %d", [subject.homework count]];
    return cell;
}



@end
