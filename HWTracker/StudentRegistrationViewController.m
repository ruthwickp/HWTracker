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

#pragma mark - Checking registration

// Returns whether the username is unique and valid
- (BOOL)validUsername:(NSString *)username
{
    // Checks if the username is valid
    if ([username length] < 8 || [username length] > 32 || ![username isAlphaNumeric]) {
        [self alert:@"Username must be between 8-32 characters and must contain only letters and numbers"];
        return NO;
    }
    // Makes a request for the student with the username
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    // Finds matches from request
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches) {
        NSLog(@"Error when checking uniqueness of database");
        return NO;
    }
    else if ([matches count]) {
        [self alert:@"Username is already taken. Choose another."];
        return NO;
    }
    // Cannot find a match
    else {
        return YES;
    }
}

// Shows an alert view containing the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Registration"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}




@end
