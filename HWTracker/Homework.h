//
//  Homework.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/2/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Homework : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) Subject *inClass;

@end
