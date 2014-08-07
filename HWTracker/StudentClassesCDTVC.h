//
//  StudentClassesCDTVC.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Student.h"

// Displays a students list of classes
@interface StudentClassesCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Student *student;

@end
