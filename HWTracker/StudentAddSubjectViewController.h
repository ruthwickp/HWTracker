//
//  StudentAddSubjectViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/14/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Student.h"

// Adds the subject for the current student
@interface StudentAddSubjectViewController : CoreDataTableViewController

@property (nonatomic, strong) Student *student;

@end
