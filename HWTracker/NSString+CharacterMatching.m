//
//  NSString+CharacterMatching.m
//  HWTracker
//
//  Created by Ruthwick Pathireddy on 8/9/14.
//  Copyright (c) 2014 Darkking. All rights reserved.
//

#import "NSString+CharacterMatching.h"

@implementation NSString (CharacterMatching)

// Checks if string contains only letters
- (BOOL)isAlpha
{
    NSCharacterSet *nonLetters = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:nonLetters].location == NSNotFound);
}

// Check if string contains only numbers
- (BOOL)isNumeric
{
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:nonNumbers].location == NSNotFound);
}

// Check if string contains only letters and numbers
- (BOOL)isAlphaNumeric
{
    NSCharacterSet *nonAlphaNumberic = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:nonAlphaNumberic].location == NSNotFound);
}


@end
