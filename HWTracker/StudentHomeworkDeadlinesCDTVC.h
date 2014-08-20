//
//  StudentHomeworkDeadlinesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/20/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "HomeworkDeadlinesCDTVC.h"
#import "Student.h"

// Displays homework deadlines for the given student
@interface StudentHomeworkDeadlinesCDTVC : HomeworkDeadlinesCDTVC

@property (nonatomic, strong) Student *student;

@end
