//
//  TeacherRegistrationViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/10/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherRegistrationViewController.h"
#import "NSString+CharacterMatching.h"
#import "Teacher+Create.h"

@interface TeacherRegistrationViewController ()
// Stores the teacher code
@property (weak, nonatomic) IBOutlet UITextField *teacherCodeTextField;
@end

@implementation TeacherRegistrationViewController

#pragma mark - Navigation

#define UNWIND_SEGUE_TEACHER @"Register Teacher"

// When we perform the unwind segue, we create the teacher
// object before we dismiss the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_TEACHER]) {
        [Teacher createTeacherWithName:[NSString stringWithFormat:@"%@ %@", self.firstNameTextField.text, self.lastNameTextField.text]
                              username:self.usernameTextField.text
                              password:self.passwordTextField.text
                            fromSchool:self.school];
    }
}

// Checks the values in the textfield before we proceed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:UNWIND_SEGUE_TEACHER]) {
        // Checks the name
        if (![self validFirstName] || ![self validLastName]) {
            return NO;
        }
        // Checks the username and password
        else if (![self validUsername:self.usernameTextField.text]) {
            return NO;
        }
        else if (![self doesPasswordMatch]) {
            return NO;
        }
        // Checks the codes
        else if (![self isValidSchoolCode] || ![self validTeacherCode]) {
            return NO;
        }
        // If everything is valid, posts a message saying successful registration
        else {
            [self alert:@"You have successfully registered as a Teacher. Go ahead and login to HWTracker."];
            return YES;
        }
    }
    else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

// Checks if teacher code matches the one for the school
- (BOOL)validTeacherCode
{
    if (!self.school || ![self.school.teacherCode isEqualToString:self.teacherCodeTextField.text]) {
        [self alert:@"Teacher Code does not match for the given School Code"];
        return NO;
    }
    return YES;
}

@end
