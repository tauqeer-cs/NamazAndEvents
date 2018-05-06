//
//  NSDictionary+NullReplacement.h
//  IamKarachi
//
//  Created by Tauqeer on 2015-02-28.
//  Copyright (c) 2015 Tauqeer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (NullReplacement)

- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;

@end
