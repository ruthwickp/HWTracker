//
//  RegistrationViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AddObjectViewController.h"
#import "School.h"

// Contains basic textfields for registration
@interface RegistrationViewController : AddObjectViewController

// Outlets to text fields
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *schoolCodeTextField;

// Methods for checking textfield input
- (BOOL)validFirstName;
- (BOOL)validLastName;
- (BOOL)doesPasswordMatch;
- (BOOL)isValidSchoolCode;

// Stores school from user inputted textfield
@property (nonatomic, strong) School *school;

// Abstract method
// Must override this for person specific registration
- (BOOL)validUsername:(NSString *)username;

@end
