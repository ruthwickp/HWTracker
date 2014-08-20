//
//  TeacherDisplayHomeworkViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherDisplayHomeworkViewController.h"
#import "Homework.h"
#import "Subject.h"
#import "ManagedObjectChangedNotification.h"

@interface TeacherDisplayHomeworkViewController () <UITextViewDelegate>
@property (nonatomic) CGFloat animatedDistance;
@end

@implementation TeacherDisplayHomeworkViewController

#pragma mark - Homework Editing

// Allows the teacher to edit the textviews
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Removes keyboard when tapped
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

// Removes keyboard from view
- (void)removeKeyboard
{
    [self.view endEditing:YES];
}

// Makes the textviews editable
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self makeTextViewsEditable:YES];
    }
    else {
        // If the user clicked done but entered incorrect
        // input, done will not be showed
        if (![self validTextViews]) {
            [self setEditing:YES animated:animated];
            return;
        }
        // We update homework if input is valid
        else {
            [self makeTextViewsEditable:NO];
            [self updateHomework];
        }
    }
}

// Updates homework with input from the textfields
- (void)updateHomework
{
    [self updateAllHomeworkInstances];
    self.title = self.titleTextView.text;
    // Posts notification when subject is changed
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATED_HOMEWORK_NOTIFICATION object:self];
}

// Updates all instances of homework. Method is used so that
// all the subjects for the students can get an update for
// their homework.
- (void)updateAllHomeworkInstances
{
    // Gets all the homework that match
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Homework"];
    request.predicate = [NSPredicate predicateWithFormat:@"(dueDate = %@) AND (info = %@) AND (title = %@) AND (inClass.name = %@) AND (inClass.teacher = %@)", self.homework.dueDate, self.homework.info, self.homework.title, self.homework.inClass.name, self.homework.inClass.teacher];
    
    // Finds matches from request
    NSError *error;
    NSArray *matches = [[self.homework managedObjectContext] executeFetchRequest:request error:&error];
    if (error || !matches) {
        NSLog(@"Error when trying to update homework for all subjects: %@", error);
    }
    else {
        [matches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // Updates the homework
            if ([obj isKindOfClass:[Homework class]]) {
                Homework *eachHomework = (Homework *)obj;
                eachHomework.title = self.titleTextView.text;
                eachHomework.info = self.descriptionTextView.text;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd-yyyy"];
                eachHomework.dueDate = [dateFormatter dateFromString:self.dueDateTextView.text];
            }
        }];
    }

}

// Helper function to make textviews editable or not
- (void)makeTextViewsEditable:(BOOL)editable
{
    self.titleTextView.editable = editable;
    self.descriptionTextView.editable = editable;
    self.dueDateTextView.editable = editable;
}

// Determines whether the textfields are valid
- (BOOL)validTextViews
{
    if ([[self.titleTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self alert:@"Homework needs title"];
        return NO;
    }
    if ([[self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self alert:@"Description needs title"];
        return NO;
    }
    if (![self validDate]) {
        return NO;
    }
    return YES;
}

// Returns whether the date is valid
- (BOOL)validDate
{
    // Makes sure date is formatted correctly
    NSString *dateString = [self.dueDateTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([dateString characterAtIndex:2] != '-' || [dateString characterAtIndex:5] != '-' || [dateString length] != 10) {
        [self alert:@"Invalid date format (MM-dd-yyyy)"];
        return NO;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *dueDate = [dateFormatter dateFromString:dateString];
    
    
    // Makes components to only compare dates, not times
    NSInteger comps = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *homeworkDateComponents = [calendar components:comps fromDate:dueDate];
    NSDateComponents *todayDateComponents = [calendar components:comps fromDate:[NSDate date]];
    
    // Makes sure date is valid
    NSDate *homeworkDate = [calendar dateFromComponents:homeworkDateComponents];
    NSDate *todayDate = [calendar dateFromComponents:todayDateComponents];
    if ([homeworkDate compare:todayDate] == NSOrderedAscending) {
        [self alert:@"Date is invalid"];
        return NO;
    }
    return YES;
}

// Shows an alert view containing the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Editing Homework"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}

#pragma mark - Animating TextView

// Constants used for animating textViews
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Finds the rectangles in the window of the app
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    // Calculates the fraction of the height to move the view
    CGFloat midline = textViewRect.origin.y + .5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    // Makes sure fraction does not exceeds out of the view
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    // Animates the movement of the view
    self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // Moves the view up by the animated distance
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y -= self.animatedDistance;
                         [self.view setFrame:viewFrame];
                     }
                     completion:nil];
}

// Moves the textviews down when finished editing
- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Animates movement of the view
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // Moves the view down by the animated distance
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y += self.animatedDistance;
                         [self.view setFrame:viewFrame];
                     }
                     completion:nil];
}

@end
