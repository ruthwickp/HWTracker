//
//  HomeViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/3/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeViewController.h"
#import "DatabaseAvailability.h"
#import <CoreData/CoreData.h>
#import "StudentClassesCDTVC.h"
#import "TeacherClassesCDTVC.h"
#import "Student+Create.h"
#import "Teacher+Create.h"
#import "StudentRegistrationViewController.h"
#import "TeacherRegistrationViewController.h"

@interface HomeViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

// Makes the view controller listen for context notifications
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.context = note.userInfo[DatabaseContext];
                                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Removes keyboard when tapped
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

// Removes keyboard from view
- (void)removeKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Button Presses

#define STUDENT_LOGIN @"Student Login"
#define TEACHER_LOGIN @"Teacher Login"

// Determines whether or not to login when button is pressed
- (IBAction)loginButtonPressed:(UIButton *)sender {
    // Sees if a student login was successful and segues
    if ([self studentLoginSuccessful]) {
        [self performSegueWithIdentifier:STUDENT_LOGIN sender:sender];
    }
    // Checks if teacher login was successful and segues
    else if ([self teacherLoginSuccessful]) {
        [self performSegueWithIdentifier:TEACHER_LOGIN sender:sender];
    }
    else {
        // If no match, pop up an alert view with error message
        [self alert:@"Invalid username or password"];
    }
}

// Displays an alert view with the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                               message:msg
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"Ok", nil] show];
}

// Returns whether the student login was successful
- (BOOL)studentLoginSuccessful
{
    BOOL match = NO;
    // Makes a request to see if a student logged in
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)",
                         self.usernameTextField.text, self.passwordTextField.text];
    
    // Determines if there is a match for student
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error in retrieving login match for student");
    }
    else if ([matches count]) {
        match = YES;
    }
    return match;
}

// Returns whether the teacher login was successful
- (BOOL)teacherLoginSuccessful
{
    BOOL match = NO;
    // Makes a request to see if a teacher logged in
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)",
                         self.usernameTextField.text, self.passwordTextField.text];
    
    // Determines if there is a match for teacher
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error in retrieving login match for teacher");
    }
    else if ([matches count]) {
        match = YES;
    }
    return match;
}


#pragma mark - TextField Delegate

// Removes keyboard when returned
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segues to first view controller if the destinationVC is in
    // a UITabBarController
    if ([segue.destinationViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = segue.destinationViewController;
        UIViewController *destinationVC = [tabBarController.viewControllers firstObject];

        // If the segue if for a student
        if ([segue.identifier isEqualToString:STUDENT_LOGIN]) {
            if ([destinationVC isKindOfClass:[StudentClassesCDTVC class]]) {
                [self prepareStudentViewController:(StudentClassesCDTVC *)destinationVC];
            }
        }
        // If the segue is for a teacher
        else if ([segue.identifier isEqualToString:TEACHER_LOGIN]) {
            if ([destinationVC isKindOfClass:[TeacherClassesCDTVC class]]) {
                [self prepareTeacherViewController:(TeacherClassesCDTVC *)destinationVC];
            }
        }
    }
    // Segues to registration view controllers by passing in context
    else if ([segue.destinationViewController isKindOfClass:[StudentRegistrationViewController class]]) {
        StudentRegistrationViewController *studentRVC = segue.destinationViewController;
        studentRVC.context = self.context;
    }
    else if ([segue.destinationViewController isKindOfClass:[TeacherRegistrationViewController class]]) {
        TeacherRegistrationViewController *teacherRVC = segue.destinationViewController;
        teacherRVC.context = self.context;
    }
}

// Prepares a view controller for the student
- (void)prepareStudentViewController:(StudentClassesCDTVC *)studentCDTVC
{
    Student *student = [Student findStudentWithUsername:self.usernameTextField.text
                                            andPassword:self.passwordTextField.text
                                 inManagedObjectContext:self.context];
    // Makes sure student exists (should always be true)
    if (student) {
        studentCDTVC.student = student;
    }
    else {
        NSLog(@"Student does not exist. Something wrong must have happened.");
    }
}

// Prepares a view controller for the teacher
- (void)prepareTeacherViewController:(TeacherClassesCDTVC *)teacherCDTVC
{
    Teacher *teacher = [Teacher findTeacherWithUsername:self.usernameTextField.text
                                               password:self.passwordTextField.text
                               inNSManagedObjectContext:self.context];
    // Makes sure teacher exists (should always be true)
    if (teacher) {
        teacherCDTVC.teacher = teacher;
    }
    else {
        NSLog(@"Teacher does not exists. Something wrong must have happened.");
    }
}

#pragma mark - Registration Action

// Used for unwinding modal view controllers
- (IBAction)registerPerson:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[StudentRegistrationViewController class]]) {
        NSLog(@"Did click on done Student");
    }
    else if ([segue.sourceViewController isKindOfClass:[TeacherRegistrationViewController class]]) {
        NSLog(@"Did click on done Teacher");
    }
}

@end
