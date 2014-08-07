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
+ (Student *)createStudentWithUsername:(NSString *)username
                           andPassword:(NSString *)password
                            fromSchool:(School *)school
{
    // Makes a request for a student
    Student *student = nil;
    NSManagedObjectContext *context = [school managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"(username = %@) AND (password = %@) AND (fromSchool = %@)",
                         username, password, school];
    
    // Finds if the student already exists
    // If not creates the student
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count] > 1) {
        NSLog(@"Error in creating student");
    }
    else if ([matches count]){
        return [matches firstObject];
    }
    else {
        // Adds object to database and sets properties
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        student.username = username;
        student.password = password;
        student.fromSchool = school;
    }
    return student;
}


@end
