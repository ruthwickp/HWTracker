//
//  School.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/2/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Teacher;

@interface School : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * schoolCode;
@property (nonatomic, retain) NSSet *teachers;
@property (nonatomic, retain) Student *students;
@end

@interface School (CoreDataGeneratedAccessors)

- (void)addTeachersObject:(Teacher *)value;
- (void)removeTeachersObject:(Teacher *)value;
- (void)addTeachers:(NSSet *)values;
- (void)removeTeachers:(NSSet *)values;

@end
