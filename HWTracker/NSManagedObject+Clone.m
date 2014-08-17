//
//  NSManagedObject+Clone.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/17/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "NSManagedObject+Clone.h"

@implementation NSManagedObject (Clone)

// Allows the NSManagedObject to be cloned
// and returns the instance
- (NSManagedObject *)clone
{
    NSString *entityName = [[self entity] name];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // New managed object is created
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                               inManagedObjectContext:context];
    
    // Copys the attributes over to the new object
    NSDictionary *attributes = [[NSEntityDescription entityForName:entityName
                                           inManagedObjectContext:context] attributesByName];
    for (NSString *attr in attributes) {
        [newObject setValue:[self valueForKey:attr] forKey:attr];
    }
    
    // Copys the relationships
    NSDictionary *relationships = [[NSEntityDescription entityForName:entityName
                                               inManagedObjectContext:context] relationshipsByName];
    for (NSString *relName in [relationships allKeys]) {
        NSRelationshipDescription *rel = [relationships objectForKey:relName];
        
        NSString *keyName = [NSString stringWithFormat:@"%@", rel];
        if ([rel isToMany]) {
            // Loops through all the objects and adds them
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *newObjectSet = [self mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while (relatedObject = [e nextObject]) {
                // Clones object and adds to set
                NSManagedObject *clonedRelatedObject = [relatedObject clone];
                [newObjectSet addObject:clonedRelatedObject];
            }
        }
        else {
            [newObject setValue:[self valueForKey:keyName] forKey:keyName];
        }
    }
    
    return newObject;
}

@end
