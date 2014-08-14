//
//  TeacherHomeworkDeadlinesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/14/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeworkDeadlinesCDTVC.h"
#import "Teacher.h"

// Class displays upcoming homework assignments for a teacher
@interface TeacherHomeworkDeadlinesCDTVC : HomeworkDeadlinesCDTVC

@property (nonatomic, strong) Teacher *teacher;

@end
