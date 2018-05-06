//
//  Wrapper.m
//  GChat
//
//  Created by Tauqeer on 2014-09-26.
//  Copyright (c) 2014 Carlin. All rights reserved.
//

#import "Wrapper.h"

@implementation Wrapper

+(void)performSegueForViewController:(UIViewController *)senderViewController segueIdentifier:(NSString *)identifier
{
    [senderViewController performSegueWithIdentifier:identifier sender:senderViewController];
    
}
@end
