//
//  AddHomeworkViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AddHomeworkViewController.h"
#import "Homework+Create.h"

@interface AddHomeworkViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) NSDate *date;
@end

@implementation AddHomeworkViewController

// Makes a border around description and sets date to now
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.descriptionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:.5] CGColor]];
    [self.descriptionTextView.layer setBorderWidth:2.0];
    [self.descriptionTextView.layer setCornerRadius:5.0];
    self.date = [NSDate date];
}

- (IBAction)selectedDate:(UIDatePicker *)sender
{
    self.date = sender.date;
}

#define CREATED_HOMEWORK @"Finished Creating Homework"

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:CREATED_HOMEWORK]) {
        if (![self validTitle]) {
            return NO;
        }
        if (![self validDescription]) {
            return NO;
        }
        if (![self validDate]) {
            return NO;
        }
    }
    return YES;
}

// Returns whether the title is valid
- (BOOL)validTitle
{
    if ([[self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self alert:@"Empty Homework Title"];
        return NO;
    }
    return YES;
}

// Returns whether the description is valid
- (BOOL)validDescription
{
    if ([[self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self alert:@"Empty Homework Description"];
        return NO;
    }
    return YES;
}

// Returns whether the date is valid
- (BOOL)validDate
{
    // Makes components to only compare dates, not times
    NSInteger comps = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *homeworkDateComponents = [calendar components:comps fromDate:self.date];
    NSDateComponents *todayDateComponents = [calendar components:comps fromDate:[NSDate date]];
    
    // Makes sure date is valid
    NSDate *homeworkDate = [calendar dateFromComponents:homeworkDateComponents];
    NSDate *todayDate = [calendar dateFromComponents:todayDateComponents];
    if ([homeworkDate compare:todayDate] == NSOrderedAscending) {
        [self alert:@"Invalid Date"];
        return NO;
    }
    return YES;
}

// Shows an alert view containing the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Homework"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:CREATED_HOMEWORK]) {
        self.homework = [Homework createHomeworkWithTitle:self.titleTextField.text
                                                     info:self.descriptionTextView.text
                                                  dueDate:self.date
                                                   status:[NSNumber numberWithBool:NO]
                                                  inClass:self.subject];
    }
}

@end
