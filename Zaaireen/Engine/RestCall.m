
//
//  RestCall.m
//  GChat
//
//  Created by Tauqeer on 2014-09-26.
//  Copyright (c) 2014 Carlin. All rights reserved.
//

#import "RestCall.h"
#import "Config.h"
#import "JSONKit.h"
#import "BaseViewController.h"
#import "NSDictionary+NullReplacement.h"
#import "NSArray+NullReplacement.h"
#import "DateFormatter.h"
#import "XMLDictionary.h"



@implementation RestCall


+(NSDictionary *)makeObjectFromJSON:(NSString *)extra{
    
    NSDictionary *JSON;
    JSON = [NSJSONSerialization JSONObjectWithData: [extra dataUsingEncoding:NSUTF8StringEncoding]
                                           options: NSJSONReadingMutableContainers
                                             error: nil];
    
    
    
    return JSON;
}
+(NSString *)encodeToJSONStringFromDictionary:(NSDictionary *)dictionary{
    

    NSError *error;
    
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    

    
    return [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
}

+(NSString *)makeSignatureWithGivenFullString:(NSString *)fullString
{
   NSString *newFull = [fullString stringByAppendingString:[BaseViewController giveServiceSalt]];
    return [BaseViewController makeMd5:newFull];
}

+(NSString *)makeSignatureWithGivenDictionary:(NSDictionary *)params withKeyArray:(NSArray *)keys
{
    NSString *fullString = @"";
    
    for (int i= 0;i<[keys count];i++ ) {
        
        if ([params objectForKey:[keys objectAtIndex:i]] == 0) {
            fullString = [fullString stringByAppendingString:@"0"];
        }
        else
            fullString = [fullString stringByAppendingString:[params objectForKey:[keys objectAtIndex:i]]];
    }
    
    NSString *newFull = [fullString stringByAppendingString:[BaseViewController giveServiceSalt]];
    
    return [BaseViewController makeMd5:newFull];
}



-(NSString *)convertArrayToString:(NSArray *)array{
    
    NSString *fullString = @"";
    
    if([array count] == 0)
        return @"";
    
    for (NSString *currentString in array) {
        fullString = [fullString stringByAppendingString:currentString];
        fullString = [fullString stringByAppendingString:@","];
        
    }
    fullString = [fullString substringToIndex:fullString.length - 1];
    
    return fullString;
    
}




+(void)callWebServiceWithTheseParams:(NSMutableDictionary *)params withSignatureSequence:(NSArray *)paramSeguence urlCalling:(NSString *)url withComplitionHandler:(void(^)(id result))completionHandler failureComlitionHandler:(void(^)(void))failureCompletionHandler
{
    
    [params setObject:@"this@that.com" forKey:@"email"];
    [params setObject:@"a6:0b:ba:db:3e:7a" forKey:@"macAddress"];
    [params setObject:@"1" forKey:@"app_id"];
    
    NSMutableArray *paramSet = [NSMutableArray new];
    [paramSet setArray:paramSeguence];
    
    [paramSet addObject:@"email"];
    [paramSet addObject:@"macAddress"];
    [paramSet addObject:@"app_id"];
    
    
    [params setValue:[RestCall makeSignatureWithGivenDictionary:params withKeyArray:paramSet]
              forKey:@"signature"];
    NSDictionary *jsonDictionary = params;
    NSError *error;
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    NSAssert(httpBody, @"dataWithJSONObject error: %@", error);
    
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request2 setHTTPBody:httpBody];
    
    NSString *sending = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",sending);
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            
            NSLog(@"sendAsynchronousRequest error: %@", connectionError);
        
            failureCompletionHandler();
            
            return;
        }
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        completionHandler([dictionary dictionaryByReplacingNullsWithBlanks]);
        
        
    }];
    
    
    
}

-(void)callWebServiceWithTheseParams:(NSMutableDictionary *)params withSignatureSequence:(NSArray *)paramSeguence urlCalling:(NSString *)url withComplitionHandler:(void(^)(id result))completionHandler
{
    [params setValue:[RestCall makeSignatureWithGivenDictionary:params withKeyArray:paramSeguence]
              forKey:@"signature"];
    
    NSDictionary *jsonDictionary = params;
    
    
    NSError *error;
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    NSAssert(httpBody, @"dataWithJSONObject error: %@", error);
    
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request2 setHTTPBody:httpBody];
    
    NSString *sending = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",sending);
    //NSLog(@"%@",[[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding]);
    
    [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            
            NSLog(@"sendAsynchronousRequest error: %@", connectionError);
            [self.delegate connectionErrorDelegate];
            return;
        }
        
        
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        completionHandler([dictionary dictionaryByReplacingNullsWithBlanks]);
        
    }];
    
    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"timed out");
    
}

#pragma mark EventsServices


-(void)callWeatherForImageWithCityId:(NSString *)cityId
{
    
   
    NSURL *urlLink = [[NSURL alloc] initWithString: [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",cityId]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlLink];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        
        
        NSDictionary *tmp = [NSDictionary dictionaryWithXMLParser:responseObject];
        
        
        
        NSString * check = [[[tmp objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"description"];
        id objForcast = [[[tmp objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"yweather:forecast"];
        
        id objCurrentWeather = [[[tmp objectForKey:@"channel"] objectForKey:@"item"] objectForKey:@"yweather:condition"];
        id objWeatherLocation = [[tmp objectForKey:@"channel"] objectForKey:@"yweather:location"];
        
        
        
        
        NSString *imageLink = @"";
        
        if ([check contains:@"src="]) {
        
            NSString * k = [check substringFromString:@"src"];
            
            k = [k substringFromIndex:4];
            
            k = [k substringToString:@"\""];
            
            
            if ([k length] > 3) {
            
                imageLink = k;
                
                [self.delegate weatherServicecAlledWithSuccessWithImage:imageLink withCurrentWeather:objCurrentWeather withForcast:objForcast withWeatherLocation:objWeatherLocation];
                
                //[self.delegate weatherImageLinkCalledWithSuccess:k];
            }
            
            else {
                
            }
            
        }
        
        
        
    
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *request, NSError *error){
    
        NSLog(@"Error:------>%@", [error description]);
    
    }];
    
    [operation start];
    
}




-(void)callWeatherService2
{
    

    
    
    
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSURL *baseURL = [NSURL URLWithString:
                      @"http://api.openweathermap.org/data/2.5/weather?q=Karachi,pk"
                      ];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    

    
    
    [manager GET :
     @"http://api.openweathermap.org/data/2.5/weather?q=Karachi,pk&units=metric"
       parameters:nil
          success:^(NSURLSessionDataTask *task,
                    id responseObject)
     {
         

         
         [self.delegate weatherServiceCalledWithSucces:[[responseObject objectForKey:@"main"] objectForKey:@"temp"] condition:[[[responseObject objectForKey:@"weather"] firstObject] objectForKey:@"main"]];
         


         
     }
          failure:^(NSURLSessionDataTask *task, NSError *error){
              
              
              NSLog(@"%@",task.response);
              
              NSLog(@"%@",error);
              
          }];
    
}





-(void)processParsedObject:(id)object{

    [self processParsedObject:object depth:0 parent:nil];

}

-(void)processParsedObject:(id)object depth:(int)depth parent:(id)parent{
    
    if([object isKindOfClass:[NSDictionary class]]){
        
        for(NSString * key in [object allKeys]){
            id child = [object objectForKey:key];
            [self processParsedObject:child depth:depth+1 parent:object];
        }
        
        
    }else if([object isKindOfClass:[NSArray class]]){
        
        for(id child in object){
            [self processParsedObject:child depth:depth+1 parent:object];
        }
        
    }
    else{
        //This object is not a container you might be interested in it's value
        
    
        if ([object isKindOfClass:[NSNull class]]) {
            
            
            object = nil;
            
        }
        
    
    }
    
    
}












@end
