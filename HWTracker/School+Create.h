//
//  School+Create.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "School.h"

@interface School (Create)

// Creates a school in core data and returns it
+ (School *)createSchoolWithName:(NSString *)name
                   andSchoolCode:(NSString *)code
                     TeacherCode:(NSString *)teacherCode
        inNSManagedObjectContext:(NSManagedObjectContext *)context;

// Finds the school in core data and returns it
+ (School *)findSchoolWithName:(NSString *)name
                 andSchoolCode:(NSString *)code
      inNSManagedObjectContext:(NSManagedObjectContext *)context;

@end
