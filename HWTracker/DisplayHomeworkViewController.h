//
//  DisplayHomeworkViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ViewController.h"
#import "Homework.h"

// Displays the homework information
@interface DisplayHomeworkViewController : ViewController
@property (strong, nonatomic) Homework *homework;

// Text fields displaying the information
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *dueDateTextView;

@end
