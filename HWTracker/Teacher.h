//
//  Teacher.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class School, Subject;

@interface Teacher : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *classes;
@property (nonatomic, retain) School *fromSchool;
@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addClassesObject:(Subject *)value;
- (void)removeClassesObject:(Subject *)value;
- (void)addClasses:(NSSet *)values;
- (void)removeClasses:(NSSet *)values;

@end
