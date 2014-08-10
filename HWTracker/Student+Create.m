//
//  Student+Create.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/6/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Student+Create.h"

@implementation Student (Create)

// Creates a student with a given username, password, and school
// and returns it
+ (Student *)createStudentWithName:(NSString *)name
                          Username:(NSString *)username
                          Password:(NSString *)password
                        fromSchool:(School *)school;
{
    // Finds the student currently exists in out context
    Student *student = nil;
    NSManagedObjectContext *context = [school managedObjectContext];
    student = [self findStudentWithUsername:username
                                andPassword:password
                     inManagedObjectContext:context];
    
    // Returns if it does
    if (student) {
        return student;
    }
    else {
        // Adds object to database and sets properties
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        student.name = name;
        student.username = username;
        student.password = password;
        student.fromSchool = school;
    }
    return student;
}

// Finds a student in core data with the given information
// and returns it, nil if not found
+ (Student *)findStudentWithUsername:(NSString *)username
                         andPassword:(NSString *)password
              inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Makes a request for the student
    Student *student = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@)", username, password];
    
    // Finds if the student exists
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Error in finding student");
    }
    else if ([matches count]) {
        student = [matches firstObject];
    }
    
    return student;
}

// Finds a student with the given username in core data
+ (Student *)findStudentWithUsername:(NSString *)username
              inManagedObjectContext:(NSManagedObjectContext *)context
{
    // Makes a request for the student
    Student *student = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    
    // Finds if the student exists
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Error in finding student with only username");
    }
    else if ([matches count]) {
        student = [matches firstObject];
    }
    
    return student;
}



@end
