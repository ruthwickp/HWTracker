//
//  AddHomeworkViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/13/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AddObjectViewController.h"
#import "Subject.h"

// Adds the homework for a given class
@interface AddHomeworkViewController : AddObjectViewController

@property (nonatomic, strong) Subject *subject;

// Sets the homework when completed
@property (nonatomic, strong) Homework *homework;

@end
