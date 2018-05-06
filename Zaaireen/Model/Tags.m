//
//  Tags.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Tags.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Config.h"
#import "DateFormatter.h"
#import "Landmarks.h"
#import "Personality.h"
@implementation Tags
/*
 @property (nullable, nonatomic, retain) NSNumber *tagId;
 @property (nullable, nonatomic, retain) NSNumber *targetId;
 targetType
 @property (nullable, nonatomic, retain) NSString *tag;
 @property (nullable, nonatomic, retain) NSString *createdAt;
 */


+(void)callGetTagsWithUpperLimit:(NSString *)upperLimit
                  withLowerLimit:(NSString *)lowerLimit
                       withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler
               withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
  @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-all-tags-list"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                                  [self addFromArray:body];
                                  id allCountries = [self getAll];
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"TagsDownloaded"];
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

+(id)tagSearchLandmark:(NSString *)keyWord{

    NSArray *wordsAndEmptyStrings = [keyWord componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    //id check = [words valueForKey:@"@distinctUnionOfObjects"];
    

    
    NSMutableArray *finalResult = [NSMutableArray new];
    
    for (id currentString in words) {
        
        id currentResult = [self searchMark:currentString];
        
        [finalResult addObjectsFromArray:currentResult];
    }
    
    NSMutableArray *shrineArray = [NSMutableArray new];
    NSMutableArray *landmarksArray = [NSMutableArray new];
    NSMutableArray *personalityArray = [NSMutableArray new];
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    
    
    
    for (Tags * currentObject in finalResult) {
        
        if ([currentObject.target_type isEqualToString:@"landmarks"]) {
            
            
          Landmarks *currentLandmark =  [Landmarks getById:currentObject.targetId];
           
            if ([currentLandmark.landmarkTypeDetail.title isEqualToString:@"shrine"]) {
               
                [shrineArray addObject:currentLandmark];
                
            }
            else
            {
                [landmarksArray addObject:currentLandmark];
            }
            
        }
        else
        if ([currentObject.target_type isEqualToString:@"personality"]){
            
            Personality *currentPersonality = [Personality getById:currentObject.targetId];
            if (currentPersonality) {
                [personalityArray addObject:currentPersonality];                
            }

        }
    }

    [currentDictionary setObject:shrineArray forKey:@"shrineArray"];
    [currentDictionary setObject:landmarksArray forKey:@"landmarksArray"];
    [currentDictionary setObject:personalityArray forKey:@"personalityArray"];
    
    return currentDictionary;
}


+(id)searchMark:(NSString *)keyWord{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tags"];
    
    keyWord = [@"" stringByAppendingString:[keyWord stringByAppendingString:@""]];
    
    
    request.predicate = [NSPredicate predicateWithFormat:@"ANY tag CONTAINS[cd] %@ AND (target_type == 'landmarks' OR target_type == 'personality')",keyWord];
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(id)getAllWithId:(int)tagId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tags"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tagId == %@",[NSNumber numberWithInt:tagId]];
    
    
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)addFromArray:(NSArray *)list{
    
    for (id currentObject in list) {
        

    [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
    withTargetId:(int)[[currentObject objectForKey:@"target_id"] integerValue]
    withTargetType:[currentObject objectForKey:@"target_type"]
      withTag:[currentObject objectForKey:@"tags"]
    withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                      withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        
    }
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tags"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)add:(int)tagId
withTargetId:(int)targetId
withTargetType:(NSString *)targetType
withTag:(NSString *)tag
withCreatedDate:(NSDate *)createdAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Tags ifRecordAlreadyExistsWithTagName:tagId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Tags *currentItem = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Tags"
                                 inManagedObjectContext:
                                 managedObjectContext];
    
    currentItem.tagId = [NSNumber numberWithInteger:tagId];
    currentItem.targetId = [NSNumber numberWithInteger:targetId];
    currentItem.tag = tag;
    currentItem.target_type = targetType;
    
    currentItem.createdAt = createdAt;
 
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tags"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tagId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Tags"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}
@end
