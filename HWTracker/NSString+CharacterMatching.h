//
//  NSString+CharacterMatching.h
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/9/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import <Foundation/Foundation.h>

// Provides methods to determine if a string contains
// a following list of characters
@interface NSString (CharacterMatching)

- (BOOL)isAlpha;
- (BOOL)isNumeric;
- (BOOL)isAlphaNumeric;

@end
