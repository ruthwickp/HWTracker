//
//  StudentRegistrationViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/8/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "StudentRegistrationViewController.h"
#import "Student+Create.h"
#import "NSString+CharacterMatching.h"

@interface StudentRegistrationViewController ()
@end

@implementation StudentRegistrationViewController

#pragma mark - Navigation

#define UNWIND_SEGUE_STUDENT @"Register Student"

// When we perform the unwind segue, we create the student
// object before we dismiss the view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_STUDENT]) {
        [Student createStudentWithName:[NSString stringWithFormat:@"%@ %@", self.firstNameTextField.text, self.lastNameTextField.text]
                              Username:self.usernameTextField.text
                              Password:self.passwordTextField.text
                            fromSchool:self.school];
    }

}

// Checks the values in the textfield before we proceed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:UNWIND_SEGUE_STUDENT]) {
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
        else if (![self isValidSchoolCode]) {
            return NO;
        }
        // If everything is valid, posts a message saying successful registration
        else {
            [self alert:@"You have successfully registered as a Student. Go ahead and login to HWTracker."];
            return YES;
        }
    }
    else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

@end
