//
//  Subject.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Homework, Student, Teacher;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *homework;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) Teacher *teacher;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addHomeworkObject:(Homework *)value;
- (void)removeHomeworkObject:(Homework *)value;
- (void)addHomework:(NSSet *)values;
- (void)removeHomework:(NSSet *)values;

@end
