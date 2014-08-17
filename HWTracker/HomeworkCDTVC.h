//
//  HomeworkCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/12/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Subject.h"

// Displays homework for a given subject
@interface HomeworkCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Subject *subject;

@end
