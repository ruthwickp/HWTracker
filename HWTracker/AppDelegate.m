//
//  AppDelegate.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/2/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseAvailability.h"

#import "School+Create.h"
#import "Student+Create.h"
#import "Teacher+Create.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation AppDelegate

// Posts a notification when someone sets the context
- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:@{ DatabaseContext : self.context }];
}

// Lazily instantiates the managed document
- (UIManagedDocument *)document
{
    if (!_document) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"HWTracker";
        NSURL *documentURL = [documentDirectory URLByAppendingPathComponent:documentName];
        _document = [[UIManagedDocument alloc] initWithFileURL:documentURL];

    }
    return _document;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Creates NSManagedObjectContext
    [self createContext];
    return YES;
}

// Creates or opens UIManagedDocument
- (void)createContext
{
    // Checks if file exists and opens it
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self.document fileURL] path]]) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self documentIsReady];
            }
            else {
                NSLog(@"Error, could not open file");
            }
        }];
    }
    // Creates file if it doesn't exist
    else {
        [self.document saveToURL:[self.document fileURL]
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success) {
                   if (success) {
                       [self documentIsReady];
                   }
                   else {
                       NSLog(@"Error, could not create file");
                   }
               }];
    }
}

// Sets the context when document is ready
- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        self.context = self.document.managedObjectContext;
        NSLog(@"%@", self.context);
        School *school = [School createSchoolWithName:@"Whitney" andSchoolCode:@"ASDF" inNSManagedObjectContext:self.context];
        [Student createStudentWithUsername:@"ruthwickp" andPassword:@"Ruthwick1995" fromSchool:school];
        [Teacher createTeacherWithName:@"Boss" username:@"sathwickp" password:@"asdf1234" fromSchool:school];
    }
}

@end
