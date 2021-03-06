//
//  Teacher+Create.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Teacher.h"
#import "School.h"

@interface Teacher (Create)

// Creates a teacher with the given properties in
// core data and returns it
+ (Teacher *)createTeacherWithName:(NSString *)name
                          username:(NSString *)username
                          password:(NSString *)password
                        fromSchool:(School *)school;

// Returns teacher that matches the properties
+ (Teacher *)findTeacherWithUsername:(NSString *)username
                        password:(NSString *)password
        inNSManagedObjectContext:(NSManagedObjectContext *)context;

// Returns a teacher with the following username
+ (Teacher *)findTeacherWithUsername:(NSString *)username
            inNSManagedObjectContext:(NSManagedObjectContext *)context;

@end
