//
//  RestCall.h
//  GChat
//
//  Created by Tauqeer on 2014-09-26.
//  Copyright (c) 2014 Carlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"



@protocol RestCallDelegates


@optional

-(void)serviceCalledWithSuccess:(NSMutableArray *)result;
-(void)serviceCallFailed:(NSString *)errorMessage;

-(void)registerVCardSuccess:(id)response;

-(void)registerVCardFailed;

-(void)connectionErrorDelegate;
-(void)weatherServiceCalledWithSucces:(id)temperature condition:(NSString *)condition;
-(void)getPreferredLocatonsCalledWithSucces:(id)response;
-(void)weatherImageLinkCalledWithSuccess:(NSString *)link;
-(void)weatherServicecAlledWithSuccessWithImage:(NSString *)imageLink withCurrentWeather:(id)currentWeather withForcast:(id)forcast withWeatherLocation:(id)weatherLocation;


@end

@interface RestCall : NSObject<NSXMLParserDelegate>

@property (nonatomic,strong) id<RestCallDelegates> delegate;

+(NSString *)makeSignatureWithGivenFullString:(NSString *)fullString;
+(NSString *)makeSignatureWithGivenDictionary:(NSDictionary *)params withKeyArray:(NSArray *)keys;
+(NSString *)encodeToJSONStringFromDictionary:(NSDictionary *)dictionary;

-(void)callWebServiceWithTheseParams:(NSMutableDictionary *)params withSignatureSequence:(NSArray *)paramSeguence urlCalling:(NSString *)url withComplitionHandler:(void(^)(id result))completionHandler;
+(void)callWebServiceWithTheseParams:(NSMutableDictionary *)params withSignatureSequence:(NSArray *)paramSeguence urlCalling:(NSString *)url withComplitionHandler:(void(^)(id result))completionHandler failureComlitionHandler:(void(^)(void))failureCompletionHandler;

+(NSDictionary *)makeObjectFromJSON:(NSString *)extra;

-(void)callWeatherForImageWithCityId:(NSString *)cityId;


@end
