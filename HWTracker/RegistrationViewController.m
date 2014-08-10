//
//  RegistrationViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "RegistrationViewController.h"
#import "NSString+CharacterMatching.h"
#import "School.h"

@interface RegistrationViewController ()
@end

@implementation RegistrationViewController

#pragma mark - Checking registration

// Returns whether the first name is valid
- (BOOL)validFirstName
{
    if (![self.firstNameTextField.text length] || ![self.firstNameTextField.text isAlpha]) {
        [self alert:@"Please enter valid first name"];
        return NO;
    }
    return YES;
}

// Returns whether the last name is valid
- (BOOL)validLastName
{
    if (![self.lastNameTextField.text length] || ![self.lastNameTextField.text isAlpha]) {
        [self alert:@"Please enter valid last name"];
        return NO;
    }
    return YES;
}

// Returns whether the passwords match
- (BOOL)doesPasswordMatch
{
    // Makes sure password is valid
    if ([self.passwordTextField.text length] < 6 || [self.passwordTextField.text length] > 20) {
        [self alert:@"Password must be between 6-20 characters long"];
        return NO;
    }
    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self alert:@"Passwords don't match"];
        return NO;
    }
    return YES;
}

// Returns whether the school code is valid
- (BOOL)isValidSchoolCode
{
    // Makes a request for the school
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"School"];
    request.predicate = [NSPredicate predicateWithFormat:@"schoolCode = %@", self.schoolCodeTextField.text];
    
    // Finds matches from request
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches) {
        NSLog(@"Error when requesting school code");
    }
    // Stores school for the match
    else if ([matches count]) {
        self.school = [matches firstObject];
        return YES;
    }
    [self alert:@"The school code is not valid"];
    return NO;
}

// Returns whether the username is unique and valid
// Must override this methods for person specific
// registration
- (BOOL)validUsername:(NSString *)username
{
    return NO;
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
