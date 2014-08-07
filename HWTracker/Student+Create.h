//
//  Student+Create.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/6/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Student.h"
#import "School.h"

@interface Student (Create)

// Creates a student with a given username, password, and school
// and returns it
+ (Student *)createStudentWithUsername:(NSString *)username
                           andPassword:(NSString *)password
                            fromSchool:(School *)school;

@end
