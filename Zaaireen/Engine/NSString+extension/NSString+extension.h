//
//  NSString+extension.h
//  Kha-PhoneNumberCheck
//
//  Created by Kha Huynh on 6/22/14.
//  Copyright (c) 2014 com.huka.cop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (extension)

- (NSString *)trim;
+ (BOOL)validNumberWithString:(NSString *)strNumber;

@end
