//
//  AppDelegate.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/2/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIManagedDocument *document;
@end

@implementation AppDelegate

// Lazily instantiates the managed document
- (UIManagedDocument *)document
{
    if (!_document) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"HWTracker";
        NSURL *documentURL = [documentDirectory ur]

    }
    return _document;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

@end
