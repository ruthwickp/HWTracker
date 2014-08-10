//
//  School.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/10/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Teacher;

@interface School : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * schoolCode;
@property (nonatomic, retain) NSString * teacherCode;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) NSSet *teachers;
@end

@interface School (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

- (void)addTeachersObject:(Teacher *)value;
- (void)removeTeachersObject:(Teacher *)value;
- (void)addTeachers:(NSSet *)values;
- (void)removeTeachers:(NSSet *)values;

@end
