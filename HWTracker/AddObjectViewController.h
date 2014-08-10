//
//  AddObjectViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/8/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "ViewController.h"

// View controller simply represents a basic modal view controller
// that contains text fields and deals with keyboard operations.
// Controller also deals with the cancel button presses
@interface AddObjectViewController : ViewController

// Pass in the context to make the controller add
// an object into the database
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
