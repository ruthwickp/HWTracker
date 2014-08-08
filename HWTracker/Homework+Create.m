//
//  Homework+Create.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Homework+Create.h"

@implementation Homework (Create)

// Creates a homework with the given information and returns it
+ (Homework *)createHomeworkWithTitle:(NSString *)title
                                 info:(NSString *)info
                              dueDate:(NSDate *)date
                               status:(NSNumber *)completed
                              inClass:(Subject *)subject
{
    // Makes a fetch request for the given homework
    Homework *homework = nil;
    NSManagedObjectContext *context = [subject managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Homework"];
    request.predicate = [NSPredicate predicateWithFormat:
                         @"(title = %@) AND (info = %@) AND (dueDate = %@) AND (completed = %@) AND (inClass = %@)",
                         title, info, date, completed, subject];
    
    // Finds if there already exists the homework
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count] > 1) {
        NSLog(@"Error when creating homework");
    }
    else if ([matches count]) {
        homework = [matches firstObject];
    }
    else {
        // Adds homework to core data
        homework = [NSEntityDescription insertNewObjectForEntityForName:@"Homework" inManagedObjectContext:context];
        homework.title = title;
        homework.info = info;
        homework.dueDate = date;
        homework.completed = completed;
        homework.inClass = subject;
    }
    
    return homework;
}


@end
