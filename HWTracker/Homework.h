//
//  Homework.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/12/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Subject;

@interface Homework : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Subject *inClass;

@end
