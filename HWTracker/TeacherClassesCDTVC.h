//
//  TeacherClassesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ClassesCDTVC.h"
#import "Teacher.h"

// Displays classses that the teacher is teaching
@interface TeacherClassesCDTVC : ClassesCDTVC

// Property is set when the view controller receives
// a notification that a teacher logged in
@property (nonatomic, strong) Teacher *teacher;

@end
