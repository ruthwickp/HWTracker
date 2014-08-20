//
//  StudentClassesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ClassesCDTVC.h"
#import "Student.h"

// Displays a students list of classes
@interface StudentClassesCDTVC : ClassesCDTVC

// Property is set when the view controller receives
// a notification that a student logged in
@property (nonatomic, strong) Student *student;

@end
