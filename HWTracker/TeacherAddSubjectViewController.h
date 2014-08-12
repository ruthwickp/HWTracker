//
//  TeacherAddSubjectViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/11/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AddObjectViewController.h"
#import "Teacher.h"

// Adds a subject for the following teacher
@interface TeacherAddSubjectViewController : AddObjectViewController

@property (nonatomic, strong) Teacher *teacher;

@end
