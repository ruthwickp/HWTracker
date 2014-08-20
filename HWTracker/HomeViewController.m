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
#import "Student+Create.h"
#import "Teacher+Create.h"
#import "StudentRegistrationViewController.h"
#import "TeacherRegistrationViewController.h"
#import "LoginNotification.h"

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
    Student *student = [Student findStudentWithUsername:self.usernameTextField.text
                                            andPassword:self.passwordTextField.text inManagedObjectContext:self.context];
    return student ? YES : NO;
}

// Returns whether the teacher login was successful
- (BOOL)teacherLoginSuccessful
{
    Teacher *teacher = [Teacher findTeacherWithUsername:self.usernameTextField.text
                                               password:self.passwordTextField.text inNSManagedObjectContext:self.context];
    return teacher ? YES : NO;
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
    // Segues to a UITabBarController
    if ([segue.destinationViewController isKindOfClass:[UITabBarController class]]) {
        // If the segue if for a student, we display student view controller
        if ([segue.identifier isEqualToString:STUDENT_LOGIN]) {
            [self prepareStudentViewController];
        }
        // If the segue is for a teacher, we display teacher view controller
        else if ([segue.identifier isEqualToString:TEACHER_LOGIN]) {
            [self prepareTeacherViewController];
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
- (void)prepareStudentViewController
{
    Student *student = [Student findStudentWithUsername:self.usernameTextField.text
                                            andPassword:self.passwordTextField.text
                                 inManagedObjectContext:self.context];
    // Makes sure student exists (should always be true) and posts notification
    if (student) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STUDENT_LOGIN_NOTIFICATION
                                                            object:self
                                                          userInfo:@{STUDENT_LOGIN_CONTEXT: student}];
    }
    else {
        NSLog(@"Student does not exist. Something wrong must have happened.");
    }
}

// Prepares a view controller for the teacher
- (void)prepareTeacherViewController
{
    Teacher *teacher = [Teacher findTeacherWithUsername:self.usernameTextField.text
                                               password:self.passwordTextField.text
                               inNSManagedObjectContext:self.context];
    // Makes sure teacher exists (should always be true) and posts notification
    if (teacher) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TEACHER_LOGIN_NOTIFICATION
                                                            object:self
                                                          userInfo:@{TEACHER_LOGIN_CONTEXT: teacher}];
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
