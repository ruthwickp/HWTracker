//
//  ClassesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "CoreDataTableViewController.h"

// Class deals with displaying and removing classes
// for a particular NSManagedObject
@interface ClassesCDTVC : CoreDataTableViewController

// Abstract method, must override them
- (void)addButtonPressed;

@end
