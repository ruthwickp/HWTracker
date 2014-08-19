//
//  NSManagedObject+Clone.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Clone)

// Allows the object to cloned with the following
// entities excluded
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                     exludeEntities:(NSArray *)namesOfEntitiesToExclude;

@end
