//
//  TeacherAddSubjectViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/11/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TeacherAddSubjectViewController.h"
#import "Subject+Create.h"

@interface TeacherAddSubjectViewController ()
@property (weak, nonatomic) IBOutlet UITextField *classNameTextField;
@end

@implementation TeacherAddSubjectViewController

#pragma mark - Navigation

#define UNWIND_SEGUE_IDENTIFIER @"Finished Adding Class"

// When we segue, we create the subject for it in core data
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        [Subject createSubjectWithName:self.classNameTextField.text teacher:self.teacher];
    }
}

// Makes sure input is valid before we perform the segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:UNWIND_SEGUE_IDENTIFIER]) {
        return [self validName] ? YES : NO;
    }
    else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

// Returns whether the name is valid
- (BOOL)validName
{
    if ([[self.classNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        [self alert:@"Name of class cannot be empty"];
        return NO;
    }
    return YES;
}

// Shows an alert view containing the following message
- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Adding Class"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}


@end
