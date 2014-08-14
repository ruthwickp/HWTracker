//
//  DisplayHomeworkViewController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "DisplayHomeworkViewController.h"

@implementation DisplayHomeworkViewController

// Displays homework information
- (void)displayHomeworkInfo
{
    self.title = self.homework.title;
    self.titleTextView.text = self.homework.title;
    self.descriptionTextView.text = self.homework.info;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.dueDateTextView.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.homework.dueDate]];
}

// Designs and displays the homework info
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self designTextView];
    [self displayHomeworkInfo];
}

// Designs the textview
- (void)designTextView
{
    [self.titleTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:.5] CGColor]];
    [self.titleTextView.layer setBorderWidth:2.0];
    [self.titleTextView.layer setCornerRadius:5.0];

    [self.descriptionTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:.5] CGColor]];
    [self.descriptionTextView.layer setBorderWidth:2.0];
    [self.descriptionTextView.layer setCornerRadius:5.0];
    
    [self.dueDateTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:.5] CGColor]];
    [self.dueDateTextView.layer setBorderWidth:2.0];
    [self.dueDateTextView.layer setCornerRadius:5.0];
}


@end
