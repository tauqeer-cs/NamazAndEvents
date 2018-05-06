//
//  PersonalityCharacteristics.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "PersonalityCharacteristics.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"

@implementation PersonalityCharacteristics

// Insert code here to add functionality to your managed object subclass
/*
 @property (nullable, nonatomic, retain) NSNumber *characteristicId;
 @property (nullable, nonatomic, retain) NSString *name;
 @property (nullable, nonatomic, retain) NSString *value;
 @property (nullable, nonatomic, retain) NSNumber *personalityId;

 */
+(void)callPersonalityCharacteristicsWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-personality-characteristics"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  NSLog(@"Called");
                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"PersonalityCharacteristicsDownloaded"];
                                  
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
        



        [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
    withName:[currentObject objectForKey:@"c_name"]
        withValue:[currentObject objectForKey:@"c_value"]
withPeronsalityId:(int)[[currentObject objectForKey:@"personality_id"] integerValue]
        withOrder:(int)[[currentObject objectForKey:@"order_by"] integerValue]];
        
    }
}

+(id)getAllWithPersonalityId:(int)personalityId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PersonalityCharacteristics"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"personalityId == %@",[NSNumber numberWithInt:personalityId]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderBy"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PersonalityCharacteristics"];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderBy"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    
    
    [request setSortDescriptors:sortDescriptors];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)add:(int)ItemId
      withName:(NSString *)name
      withValue:(NSString *)value
withPeronsalityId:(int)personalityId
 withOrder:(int)orderBy
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([PersonalityCharacteristics ifRecordAlreadyExistsWithTagName:ItemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    PersonalityCharacteristics *currentItem = [NSEntityDescription
                           insertNewObjectForEntityForName:@"PersonalityCharacteristics"
                           inManagedObjectContext:
                           managedObjectContext];
    
    currentItem.characteristicId = [NSNumber numberWithInt:ItemId];

    currentItem.name = name;
    currentItem.value = value;
    currentItem.personalityId =[NSNumber numberWithInt:personalityId];
    currentItem.orderBy =[NSNumber numberWithInt:orderBy];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PersonalityCharacteristics"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"characteristicId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"PersonalityCharacteristics"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}
@end
