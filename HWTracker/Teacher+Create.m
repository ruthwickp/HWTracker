//
//  Teacher+Create.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Teacher+Create.h"

@implementation Teacher (Create)

// Creates a teacher with the given properties in
// core data and returns it
+ (Teacher *)createTeacherWithName:(NSString *)name
                          username:(NSString *)username
                          password:(NSString *)password
                        fromSchool:(School *)school
{
    Teacher *teacher = nil;
    NSManagedObjectContext *context = [school managedObjectContext];
    teacher = [self findTeacherWithUsername:username
                               password:password
               inNSManagedObjectContext:context];
    
    // Checks if teacher already exists
    if (teacher) {
        return teacher;
    }
    else {
        // Adds teacher to database
        teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher"
                                                inManagedObjectContext:context];
        teacher.name = name;
        teacher.username = username;
        teacher.password = password;
        teacher.fromSchool = school;
    }
    return teacher;
}

// Returns teacher that matches the properties
+ (Teacher *)findTeacherWithUsername:(NSString *)username
                            password:(NSString *)password
            inNSManagedObjectContext:(NSManagedObjectContext *)context;
{
    // Makes a request to find the teacher
    Teacher *teacher = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    // Finds matches for teacher
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error when retrieving teacher");
    }
    else if ([matches count]) {
        teacher = [matches firstObject];
    }
    
    return teacher;
}


@end
