//
//  HomeViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/3/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation HomeViewController

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

// Determines whether of not to login when button is pressed
- (IBAction)loginButtonPressed
{
    if ([self validLoginUsernameAndPassword]) {
        
    }
}

// Returns whether of not the user name and password are valid
- (BOOL)validLoginUsernameAndPassword
{
    
}

@end
