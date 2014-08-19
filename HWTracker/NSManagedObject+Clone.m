//
//  NSManagedObject+Clone.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "NSManagedObject+Clone.h"

@implementation NSManagedObject (Clone)

// Helper method that uses a cache to prevent duplicate cloning
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    withCopiedCache:(NSMutableDictionary *)alreadyCopied
                     exludeEntities:(NSArray *)namesOfEntitiesToExclude {
    // Gets the entity name and determines whether to exclude it or not
    NSString *entityName = [[self entity] name];
    if ([namesOfEntitiesToExclude containsObject:entityName]) {
        return nil;
    }
    
    // Checks if it is in cache
    NSManagedObject *cloned = [alreadyCopied objectForKey:[self objectID]];
    if (cloned != nil) {
        return cloned;
    }
    
    // Create new object in data store
    cloned = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    [alreadyCopied setObject:cloned forKey:[self objectID]];
    
    // Loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[self valueForKey:attr] forKey:attr];
    }
    
    // Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] relationshipsByName];
    for (NSString *relName in [relationships allKeys]){
        NSRelationshipDescription *rel = [relationships objectForKey:relName];
        
        NSString *keyName = rel.name;
        if ([rel isToMany]) {
            // Get a set of all objects in the relationship
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while ( relatedObject = [e nextObject]){
                // Clone it, and add clone to set
                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                [clonedSet addObject:clonedRelatedObject];
            }
        }else {
            NSManagedObject *relatedObject = [self valueForKey:keyName];
            if (relatedObject != nil) {
                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                [cloned setValue:clonedRelatedObject forKey:keyName];
            }
        }
    }
    
    return cloned;
}

// Allows the object to cloned with the following
// entities excluded
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                     exludeEntities:(NSArray *)namesOfEntitiesToExclude {
    return [self cloneInContext:context
                withCopiedCache:[NSMutableDictionary dictionary]
                 exludeEntities:namesOfEntitiesToExclude];
}

@end
