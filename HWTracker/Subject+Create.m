//
//  Subject+Create.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Subject+Create.h"

@implementation Subject (Create)

// Creates a subject with the properties and returns it
+ (Subject *)createSubjectWithName:(NSString *)name
                           teacher:(Teacher *)teacher
                          homework:(NSSet *)homework
                           student:(Student *)student
{
    // Creates a request for the subject
    Subject *subject = nil;
    NSManagedObjectContext *context = [teacher managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    request.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (teacher = %@) AND (homework = %@) AND (student = %@)",
                         name, teacher, homework, student];
    
    // Finds if the subject already exists
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error when retrieving subject");
    }
    else if ([matches count]) {
        return [matches firstObject];
    }
    else {
        // Creates new subject in core data
        subject = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:context];
        subject.name = name;
        subject.teacher = teacher;
        subject.homework = homework;
        subject.student = student;
    }
    
    return subject;
}

// Creates a subject with the following
+ (Subject *)createSubjectWithName:(NSString *)name teacher:(Teacher *)teacher
{
    return [self createSubjectWithName:name teacher:teacher homework:nil student:nil];
}


@end
