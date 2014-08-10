//
//  School+Create.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "School+Create.h"

@implementation School (Create)

// Creates a school in core data and returns it
+ (School *)createSchoolWithName:(NSString *)name
                   andSchoolCode:(NSString *)code
                     TeacherCode:(NSString *)teacherCode
        inNSManagedObjectContext:(NSManagedObjectContext *)context;
{
    School *school = nil;
    school = [self findSchoolWithName:name
                        andSchoolCode:code
             inNSManagedObjectContext:context];
    
    // Checks if school already exists
    if (school) {
        return school;
    }
    else {
        // Adds school to database
        school = [NSEntityDescription insertNewObjectForEntityForName:@"School"
                                               inManagedObjectContext:context];
        school.name = name;
        school.schoolCode = code;
        school.teacherCode = teacherCode;
    }
    return school;
}

// Finds the school in core data and returns it
+ (School *)findSchoolWithName:(NSString *)name
                 andSchoolCode:(NSString *)code
      inNSManagedObjectContext:(NSManagedObjectContext *)context
{
    // Creates a request to find the school
    School *school = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"School"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (schoolCode = %@)", name, code];
    
    // Finds matches for school
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error when retrieving school");
    }
    else if ([matches count]) {
        school = [matches firstObject];
    }
    
    return school;
}


@end
