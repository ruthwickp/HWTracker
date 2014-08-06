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
#import "Student.h"
#import "Teacher.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextView *errorTextView;
@end

@implementation HomeViewController

#pragma mark - View Controller Lifecycle

// Makes the view controller listen for context notifications
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                      object:self
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

// Determines whether or not to login when button is pressed
- (IBAction)loginButtonPressed:(UIButton *)sender {
    // Sees if a student logged in and segues
    Student *student = [self studentLogin];
    if (student) {
        [self performSegueWithIdentifier:@"Student Login" sender:sender];
        return;
    }
    
    // Checks if teacher logged in and segues
    Teacher *teacher = [self teacherLogin];
    if (teacher) {
        [self performSegueWithIdentifier:@"Teacher Login" sender:sender];
        return;
    }
    
    // If there is no match, display error message in textview
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                                  NSForegroundColorAttributeName : [UIColor redColor] };
    NSAttributedString *errorMessage = [[NSAttributedString alloc] initWithString:@"Invalid username or password"
                                                                       attributes:attributes];
    self.errorTextView.attributedText = errorMessage;
    self.errorTextView.textAlignment = NSTextAlignmentCenter;

}


// Returns a Student with the given username and password
- (Student *)studentLogin
{
    Student *student = nil;
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // Makes a request to see if a student logged in
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    // Determines if there is a match for student
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error in retrieving login match for student");
    }
    else if ([matches count]) {
        student = [matches firstObject];
    }
    return student;
}

// Returns whether the teacher login was valid
- (Teacher *)teacherLogin
{
    Teacher *teacher = nil;
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // Makes a request to see if a teacher logged in
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    // Determines if there is a match for teacher
    NSError *error;
    NSArray *matches = [self.context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error in retrieving login match for teacher");
    }
    else if ([matches count]) {
        teacher = [matches firstObject];
    }
    return teacher;
}

@end
