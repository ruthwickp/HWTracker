//
//  TabBarInsideNavigationController.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/7/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "TabBarInsideNavigationController.h"

@interface TabBarInsideNavigationController ()

@end

@implementation TabBarInsideNavigationController

// Hides navigation back button
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

@end
