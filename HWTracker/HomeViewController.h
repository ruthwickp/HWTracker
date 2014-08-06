//
//  HomeViewController.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/3/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <UIKit/UIKit.h>

// View controller for login page
@interface HomeViewController : UIViewController

// Context for objects in the database
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
