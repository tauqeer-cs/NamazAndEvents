//
//  Source_detail.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Source_detail.h"
#import "Source.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"


@implementation Source_detail


+(void)callSourceDetailWithUpperLimit:(NSString *)upperLimit
                       withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId
                withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-ziaraat-source-detail"]
                      withComplitionHandler:^(id result)
                    {
                          
                        @try {
                            
                            if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                
                                id body = [result objectForKey:@"body"];
                                [self addFromArray:body];
                                id allCountries = [self getAll];
                                NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                [currentUserDefault setObject:@"1" forKey:@"SourceDetailDownloaded"];
                                completionHandler(allCountries);
                                
                            }
                            else{
                                failureHandler();
                            }
                            
                        }
                        @catch (NSException *exception) {
                            
                            failureHandler();
            
                        }
                        
                      } failureComlitionHandler:^{
                          
                          failureHandler();
                          
                      }];
    
    
}

+(void)addFromArray:(NSArray *)list{
    
    

    for (id currentObject in list) {
        

        Source * source = [Source getById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"source_id"] integerValue]]];
        
        if (source) {
            [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
         withSourceId:(int)[[currentObject objectForKey:@"source_id"] integerValue]
         withTargetId:(int)[[currentObject objectForKey:@"target_id"] integerValue]
       withTargetType:[currentObject objectForKey:@"target_type"]
      withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
           withSource:source
      withUpdatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
        }

        
      /*  [self add:
        withTitle:[currentObject objectForKey:@"title"]
       withDetail:[currentObject objectForKey:@"description"]
  withCreatedDate:
    withUpdatedAt:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                    withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        
        */
        
    }
    

}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source_detail"];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)add:(int)sourceDetailId
withSourceId:(int)sourceId
withTargetId:(int)target_id
withTargetType:(NSString *)targetType
withCreatedDate:(NSDate *)createdAt
withSource:(Source *)source
withUpdatedDate:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Source_detail ifRecordAlreadyExistsWithTagName:sourceDetailId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Source_detail *currentItem = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Source_detail"
                                 inManagedObjectContext:
                                 managedObjectContext];
    
   currentItem.sourceDetailId = [NSNumber numberWithInt:sourceDetailId];
    currentItem.sourceId = [NSNumber numberWithInt:sourceDetailId];
    currentItem.target_id = [NSNumber numberWithInt:target_id];
    currentItem.targetType = targetType;
    currentItem.createdAt = createdAt;
    currentItem.source = source;
    currentItem.updatedAt = updatedAt;
    
    //currentItem.updated = updatedAt;
    
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(Source_detail *)getById:(NSNumber *)Id
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source_detail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"sourceDetailId == %@",Id];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results[0];
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source_detail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"sourceDetailId == %@",[NSNumber numberWithInt:Id]];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    if ([results count] > 0) {
        
        return YES;
    }
    return NO;
}

+(void)removeAllObject{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source_detail"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}

@end
