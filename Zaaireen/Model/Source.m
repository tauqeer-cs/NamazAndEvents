//
//  Source.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Source.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"

@implementation Source

// Insert code here to add functionality to your managed object subclass
/*
 NSString *author;
 NSDate *createdAt;
 NSString *detail;
 NSString *extra;
 NSDate *publishedAt;
 NSString *reviewedBy;
 NSNumber *sourceId;
 NSString *sourceUrl;
 NSString *title;
 NSDate *updatedAt;
 */

+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SourcesPropertyList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    id body = dict;
    
    [self addFromArray:body];
    id allCountries = [self getAll];
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    [currentUserDefault setObject:@"1" forKey:@"SourceDownloaded"];
    completionHandler(allCountries);
    

    
}


+(void)callSourceWithUpperLimit:(NSString *)upperLimit
                       withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId
                withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",
       @"lower_limit",
       ]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-ziaraat-source-list"]
                      withComplitionHandler:^(id result)
     {
         
         @try {
             
             if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                 
                 id body = [result objectForKey:@"body"];
                 [self addFromArray:body];
                 id allCountries = [self getAll];
                 NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                 [currentUserDefault setObject:@"1" forKey:@"SourceDownloaded"];
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

+(void)addFromArray:(id)list{
    
    for (id currentObject in list) {
        

        
        if ([currentObject isKindOfClass:[NSString class]]) {
            

            
            [self add:(int)[[[list objectForKey:currentObject] objectForKey:@"id"] integerValue]
       withReviewedBy:[[list objectForKey:currentObject] objectForKey:@"reviewed_by"]
            withExtra:[[list objectForKey:currentObject] objectForKey:@"extra"]
           withAuthor:[[list objectForKey:currentObject] objectForKey:@"author"]
           withDetail:[[list objectForKey:currentObject] objectForKey:@"description"]
        withSourceUrl:[[list objectForKey:currentObject] objectForKey:@"sourceurl"]
            withTitle:[[list objectForKey:currentObject] objectForKey:@"title"]
      withPublishedAt:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"publish_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withCreatedDate:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withUpdatedDate:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"updated_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
        }
        else {
            [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
       withReviewedBy:[currentObject objectForKey:@"reviewed_by"]
            withExtra:[currentObject objectForKey:@"extra"]
           withAuthor:[currentObject objectForKey:@"author"]
           withDetail:[currentObject objectForKey:@"description"]
        withSourceUrl:[currentObject objectForKey:@"sourceurl"]
            withTitle:[currentObject objectForKey:@"title"]
      withPublishedAt:[DateFormatter makeDataFromString:[currentObject objectForKey:@"publish_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withUpdatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        }
    }
    

    
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)add:(int)sourceId
withReviewedBy:(NSString *)reviewedBy
withExtra:(NSString *)extra
withAuthor:(NSString *)author
withDetail:(NSString *)detail
withSourceUrl:(NSString *)sourceUrl
withTitle:(NSString *)title
withPublishedAt:(NSDate *)publishedAt
withCreatedDate:(NSDate *)createdAt
withUpdatedDate:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Source ifRecordAlreadyExistsWithTagName:sourceId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Source *currentItem = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Source"
                                  inManagedObjectContext:
                                  managedObjectContext];
    
    currentItem.sourceId = [NSNumber numberWithInt:sourceId];
    currentItem.reviewedBy = reviewedBy;
    currentItem.extra = extra;
    currentItem.author =author;
    currentItem.detail = detail;
    currentItem.sourceUrl = sourceUrl;
    currentItem.title = title;
    currentItem.publishedAt = publishedAt;
    currentItem.createdAt =createdAt;
    currentItem.updatedAt = updatedAt;
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}



+(Source *)getById:(NSNumber *)Id
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"sourceId == %@",Id];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] == 0) {
        
        return nil;
        
    }
    return results[0];
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"sourceId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Source"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}




@end
