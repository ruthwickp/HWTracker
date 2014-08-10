//
//  AddObjectViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/8/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AddObjectViewController.h"

@interface AddObjectViewController () <UITextFieldDelegate>
// Stores animatedDistance
@property (nonatomic) CGFloat animatedDistance;

@end

@implementation AddObjectViewController

#pragma mark - Keyboard Editing

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

// Removes keyboard when return is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Animating TextFields

// Constants used for animating textfields
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

// Moves textfields up when keyboard appears
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Finds the rectangles in the window of the app
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    // Calculates the fraction of the height to move the view
    CGFloat midline = textFieldRect.origin.y + .5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    // Makes sure fraction does not exceeds out of the view
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    // Animates the movement of the view
    self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // Moves the view up by the animated distance
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y -= self.animatedDistance;
                         [self.view setFrame:viewFrame];
                     }
                     completion:nil];
}

// Moves the textfields down when finished editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Animates movement of the view
    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         // Moves the view down by the animated distance
                         CGRect viewFrame = self.view.frame;
                         viewFrame.origin.y += self.animatedDistance;
                         [self.view setFrame:viewFrame];
                     }
                     completion:nil];
}

#pragma mark - Button Presses and Navigation

// Removes modal view controller when cancel is pressed
- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
