//
//  Subject+Create.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Subject.h"
#import "Teacher.h"

@interface Subject (Create)

// Creates a subject with the properties and returns it
+ (Subject *)createSubjectWithName:(NSString *)name
                           teacher:(Teacher *)teacher;

@end
