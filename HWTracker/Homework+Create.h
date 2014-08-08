//
//  Homework+Create.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "Homework.h"
#import "Subject.h"

@interface Homework (Create)

// Creates a homework with the given information and returns it
+ (Homework *)createHomeworkWithTitle:(NSString *)title
                                 info:(NSString *)info
                              dueDate:(NSDate *)date
                               status:(NSNumber *)completed
                              inClass:(Subject *)subject;
@end
