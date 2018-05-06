//
//  NSString+extension.m
//  Kha-PhoneNumberCheck
//
//  Created by Kha Huynh on 6/22/14.
//  Copyright (c) 2014 com.huka.cop. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)validNumberWithString:(NSString *)strNumber {
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:strNumber];
    return [alphaNums isSupersetOfSet:inStringSet];
}


@end
