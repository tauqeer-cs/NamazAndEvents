//
//  FileManager.m
//  
//
//  Created by Tauqeer on 2014-10-17.
//  Copyright (c) 2014 Tauqeer. All rights reserved.
//

#import "FileManager.h"
#import "Config.h"
#import "Asset.h"

@implementation FileManager

+(NSString *)saveImageToDisk :(UIImage *)imageToSave
{
    
    NSData * imageData = UIImagePNGRepresentation(imageToSave);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
            return @"error creating folder";
            
        }
    }
    
    NSString *savedImagePath = [dataPath stringByAppendingPathComponent:[FileManager generateRandomString:10]];
    
    [imageData writeToFile:savedImagePath atomically:NO];
    
    return savedImagePath;
}

+(void)saveProfileImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"UserProfileImage"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(void)saveCoverImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CoverImages"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}


+(BOOL )fileCoverExistsAtPath:(NSString *)directory{
    
    
    if (!directory) {
        return NO;
        
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CoverImages"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(BOOL )fileExistsAtPath:(NSString *)directory{
    
    if (!directory) {
        return NO;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"UserProfileImage"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}



+(UIImage *)getImage:(NSString *)directory{
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"UserProfileImage"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
 
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}


+(UIImage *)getCoverImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CoverImages"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}





+(NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

+(void)loadProfileImage : (UIImageView *)imageToBeLoaded url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    


    if (!urlToLoad) {
        
        imageToBeLoaded.image = [UIImage imageNamed:@"180px-Male-icon"];
        
        [loader stopAnimating];
        
        return;
        
    }
    
    if ([FileManager fileExistsAtPath:pathName])
    {
        imageToBeLoaded.image = [FileManager getImage:pathName];
        [loader stopAnimating];
        
    }
    else {
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            if (!imageData) {
                
                return;
                
            }
            [FileManager saveProfileImageToDisk:imageData
                                       fileName:pathName];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
                [loader stopAnimating];
                
            });
        });
        
        
    }
}

+(void)loadProfileImageToButton : (UIButton *)button :(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!urlToLoad) {
        
        
        [loader stopAnimating];
        
        return;
        
    }
    
    if ([FileManager fileExistsAtPath:pathName])
    {
        [button setImage:[FileManager getImage:pathName] forState:UIControlStateNormal];
        
        [loader stopAnimating];
        
    }
    else {
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            //UIImage
            //image_yellow
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            if (!imageData) {
                
                return;
            }
            if (!imageData) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI

                    
                    
                    [loader stopAnimating];
                    
                });
                
                
                return;
            }
            
            [FileManager saveProfileImageToDisk:imageData
                                       fileName:pathName];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                
                [button setImage:
                 [UIImage imageWithData:imageData]
                        forState:UIControlStateNormal];
                [loader stopAnimating];
                
            });
        });
        
        
    }
}

+(UIImage *)loadProfileImageFromUrl:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    

    
    if ([FileManager fileExistsAtPath:pathName])
    {
        UIImage *imageToShow = [FileManager getImage:pathName];
        return imageToShow;
        
        
    }
    
    return nil;

}


+(void)loadProfileImage : (UIImageView *)imageToBeLoaded url:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!urlToLoad) {

        if ([imageToBeLoaded isKindOfClass:[UIImageView class]]){
        imageToBeLoaded.image = [UIImage imageNamed:@"180px-Male-icon"];
        }
        
        return;
    }
    
    if ([FileManager fileExistsAtPath:pathName])
    {
        if ([imageToBeLoaded isKindOfClass:[UIImageView class]]) {
        imageToBeLoaded.image = [FileManager getImage:pathName];
            
        }


    }
    else {
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if (!imageData) {
                
                return;
            }
            
            [FileManager saveProfileImageToDisk:imageData
                                       fileName:pathName];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
             
            });
        });
        
        
    }
}


+(void)giveProfileImage : (UIImageView *)imageToBeLoaded url:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    NSLog(@"%@",urlToLoad);
    
    if ([FileManager fileExistsAtPath:pathName])
    {
        imageToBeLoaded.image = [FileManager getImage:pathName];
    }
    else {
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if (!imageData) {
                
                return;
            }
            
            [FileManager saveProfileImageToDisk:imageData
                                       fileName:pathName];
            
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
            });
        });
        
        
    }
}

+(UIImage *)loadLandmarkImageFromurl:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileCoverExistsAtPath:pathName])
    {
        
        UIImage *tmp = [self getCoverImage:pathName];
        return tmp;
    }
    
    return nil;
    
}



+(void)loadLandmarkImageByHeight : (UIImageView *)imageToBeLoaded
                      url:(NSString *)urlToLoad
{
    
    if (!urlToLoad || [urlToLoad length] == 0) {
        return;
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    NSLog(@"%@",urlToLoad);
    
    if ([FileManager fileCoverExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getCoverImage:pathName];
   
        double ratio = imageToBeLoaded.image.size.height/imageToBeLoaded.frame.size.height;
        
        if (ratio >= 1) {
            double newWidth = imageToBeLoaded.image.size.width / ratio;
            double newheight = imageToBeLoaded.frame.size.height;
            UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(newWidth, newheight)];
            imageToBeLoaded.image = tmp;
            imageToBeLoaded.contentMode = UIViewContentModeCenter;
        }
        else{
            
            imageToBeLoaded.contentMode = UIViewContentModeTop;
        }

        
        [imageToBeLoaded setClipsToBounds:YES];
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"image/"] stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if (!imageData) {

                return ;
            }
            
            [FileManager
             saveCoverImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
                double finalHeigh = (imageToBeLoaded.image.size.height * imageToBeLoaded.frame.size.width)/imageToBeLoaded.image.size.width;
                
                UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(imageToBeLoaded.frame.size.width, finalHeigh)];
                
                imageToBeLoaded.image = tmp;
                
                double ratio = imageToBeLoaded.image.size.height/imageToBeLoaded.frame.size.height;
                
                if (ratio >= 1) {
                    double newWidth = imageToBeLoaded.image.size.width / ratio;
                    double newheight = imageToBeLoaded.frame.size.height;
                    UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(newWidth, newheight)];
                    imageToBeLoaded.image = tmp;
                    imageToBeLoaded.contentMode = UIViewContentModeCenter;
                    [imageToBeLoaded setClipsToBounds:YES];
        
                    
                }
                else{
                    
                    imageToBeLoaded.contentMode = UIViewContentModeTop;
                    
                    [imageToBeLoaded setClipsToBounds:YES];
                    
                }

                
                
                
            });
        });
        
        
    }
}


+(UIImage *)getLandmarkImageFrom:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];

    
    return [FileManager getCoverImage:pathName];
}

+(void)loadLandmarkImage : (UIImageView *)imageToBeLoaded
                      url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    if ([FileManager fileCoverExistsAtPath:pathName])
    {
        if (!imageToBeLoaded) {
            return;
        }
        
        imageToBeLoaded.image = [FileManager getCoverImage:pathName];
        double finalWidth = (imageToBeLoaded.image.size.width * imageToBeLoaded.frame.size.height)/imageToBeLoaded.image.size.height;
       

        UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];

        NSLog(@"%f %f",tmp.size.height,imageToBeLoaded.frame.size.height);
        
        if (tmp.size.height < imageToBeLoaded.frame.size.height) {
            
        
            double finalHeight = (imageToBeLoaded.image.size.height * imageToBeLoaded.frame.size.width)/imageToBeLoaded.image.size.width;
            tmp = nil;
            
            tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(imageToBeLoaded.frame.size.width, finalHeight)];
            [loader startAnimating];
            
            
        }
        
        imageToBeLoaded.image = tmp;
        
        if (!imageToBeLoaded) {
            tmp = nil;
            return;
        }
        [imageToBeLoaded setClipsToBounds:YES];
        
        //setClipsToBounds:YES
        imageToBeLoaded.contentMode = UIViewContentModeCenter;
        
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"image/"] stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if (!imageData) {
                
                return ;
            }
            
            [FileManager
             saveCoverImageToDisk:imageData
                        fileName:pathName];
            
            
            
            if (!imageToBeLoaded) {
                imageData= nil;
                
                return;
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                double finalWidth = (imageToBeLoaded.image.size.width * imageToBeLoaded.frame.size.height)/imageToBeLoaded.image.size.height;
                UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];
                
                imageToBeLoaded.image = tmp;
                
                [imageToBeLoaded setClipsToBounds:YES];
                
                imageToBeLoaded.contentMode = UIViewContentModeCenter;
                [loader stopAnimating];
                
                
            });
        });
        
        
    }
}


+(void)loadCoverImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader withFrameHeight:(int)frameHeight withFrameWidth:(int)frameWidth
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if (!urlToLoad) {
        imageToBeLoaded.image = [UIImage imageNamed:@"imgo.jpg"];
        
        [loader stopAnimating];
        
        return;
        
    }
    
    
    if ([FileManager fileCoverExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getCoverImage:pathName];
        
        
       
        double finalWidth = (imageToBeLoaded.image.size.width * frameHeight)/imageToBeLoaded.image.size.height;
        
        UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, frameHeight)];
        
        imageToBeLoaded.image = tmp;
        
        imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                return;
            }
            

            
            [FileManager
             saveCoverImageToDisk:imageData
             fileName:pathName];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
    
                
                double finalWidth = (imageToBeLoaded.image.size.width * frameHeight)/imageToBeLoaded.image.size.height;
                
                UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, frameHeight)];
                
                imageToBeLoaded.image = tmp;
                
                imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
        
                
                [loader stopAnimating];
                
                
            });
        });
        
        
    }
}

+(UIImage *)loadCoverImageFromurl:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    if ([FileManager fileCoverExistsAtPath:pathName])
    {
        UIImage *tmp = [FileManager getCoverImage:pathName];
        return tmp;

    }
    return nil;
}


+(void)saveCityVoiceReportTypeImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoiceReportType"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(UIImage *)getCityVoiceReportTypeImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoiceReportType"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}

+(BOOL )fileCityVoiceExistsAtPath:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoiceReportType"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(void)loadReportTypeImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    
    if ([FileManager fileCityVoiceExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getCityVoiceReportTypeImage:pathName];
        
        [loader removeFromSuperview];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            //NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if (!imageData) {
                
                return;
            }
            
            [FileManager
             saveCityVoiceReportTypeImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                [loader removeFromSuperview];
                
                
            });
        });
        
        
    }
}








#pragma mark CityVoice

+(UIImage *)getCityVoiceImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoice"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}


+(BOOL )fileCoverImagesExistsAtPath:(NSString *)directory{
    
    if(!directory)
    {
        return NO;
        
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoice"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}


+(void)saveCityVoiceImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"CityVoice"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}


+(void)loadEventMediaImage : (UIImageView *)imageToBeLoaded
                       url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!pathName) {
        
        return;
        
        
    }
    
    if ([FileManager fileEventExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getEventImage:pathName];
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                return ;
            }
            
            [FileManager
             saveEventImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                
                
                
                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
                
                
                [loader stopAnimating];
                
                
                
                
                
            });
        });
        
        
    }
}






+(void)loadCityVoiceImage : (UIImageView *)imageToBeLoaded
                        url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    
    
    if ([urlToLoad isKindOfClass:[NSNull class]]) {
        
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!pathName) {
        
        return;
        
        
    }
    
    if ([FileManager fileCoverImagesExistsAtPath:pathName])
    {
        
        
        imageToBeLoaded.image = [FileManager getCityVoiceImage:pathName];
        
        double finalWidth = (imageToBeLoaded.image.size.width * imageToBeLoaded.frame.size.height)/imageToBeLoaded.image.size.height;
        
        UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];
        imageToBeLoaded.image = tmp;
        
        
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            if (!imageData) {
                
                return;
            }
            

            [FileManager
             saveCityVoiceImageToDisk:imageData
             fileName:pathName];
            
            
            

            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI


                
                
                    imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
                double finalWidth = (imageToBeLoaded.image.size.width * imageToBeLoaded.frame.size.height)/imageToBeLoaded.image.size.height;
                
                UIImage *tmp = [FileManager scaleImage:imageToBeLoaded.image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];
                imageToBeLoaded.image = tmp;
        
                
                
                [loader stopAnimating];
                    
                    
                
                
                
            });
        });
        
        
    }
}


#pragma mark Directory

+(UIImage *)getDirectoryImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Directory"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}


+(BOOL )fileDirectoryExistsAtPath:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Directory"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}


+(void)saveDirectoryImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Directory"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(void)loadDirectoryImage : (UIImageView *)imageToBeLoaded
                       url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if ([FileManager fileDirectoryExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getDirectoryImage:pathName];
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
            
                return;
            
            }
            
            [FileManager
             saveDirectoryImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                

                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                
                
                
                [loader stopAnimating];
                
                
                
                
                
            });
        });
        
        
    }
}



#pragma mark Events

+(UIImage *)getEventImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Event"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}


+(BOOL )fileEventExistsAtPath:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Event"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}


+(void)saveEventImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Event"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}


+(UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    
    
    CGRect scaledImageRect = CGRectMake(0, 0, newSize.width, newSize.height );
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0.0 );
    
    [image drawInRect:scaledImageRect];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


+(void)loadEventImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    
    if ([FileManager fileEventExistsAtPath:pathName])
    {
        
        imageToBeLoaded.image = [FileManager getEventImage:pathName];
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            [FileManager
             saveEventImageToDisk:imageData
             fileName:pathName];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                

                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                [loader stopAnimating];
                UIImage *image = imageToBeLoaded.image;
                
                double height = image.size.height;
                double width = image.size.width;
                
                
                if (height > 580) {
                    
                    double ratio = height/580.0;
                    
                    
                    [FileManager scaleImage:image toSize:CGSizeMake(width/ratio, height/ratio)];
                    
                    [imageToBeLoaded setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                    
                    
                }
                else{
                    
                    
                    if (height > 290) {
                        double divideValue = height/290.0;
                        double newHe = height/divideValue;
                        double nWid = width/divideValue;
                        
                        [imageToBeLoaded setFrame:CGRectMake(0, 0, nWid, newHe)];
                        
                    }
                    else
                        [imageToBeLoaded setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
                    
                }
                
                
                
                int c1 = [imageToBeLoaded superview].center.x;
                int c2 = [imageToBeLoaded superview].center.y;
                
                
                
                [imageToBeLoaded setCenter:CGPointMake(c1, c2)];
                
                
                
                
                
            });
        });
        
        
    }
}




#pragma mark



+(void)loadFeedsImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader withFinalWidt:(int)width height:(int)height removeView:(UIView *)removingView{
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!pathName) {
        
        return;
        
        
    }
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        
        
        UIImage *image = [FileManager getFeedsImage:pathName];
        double he = image.size.height;
        double orignalwidth = image.size.width;
        
        double finalWidth = (image.size.width * 151.0)/image.size.height+25;
        
        if (he >= 151) {
            
            UIImage *tmp = [FileManager scaleImage:image toSize:CGSizeMake(finalWidth, 151)];
            
            imageToBeLoaded.image = tmp;
            
        }
        else
        {
            

            imageToBeLoaded.clipsToBounds = YES;
            imageToBeLoaded.image = image;
            
        }
        
        UIView *mySuperView = imageToBeLoaded.superview;
        [mySuperView sendSubviewToBack:imageToBeLoaded];
        [imageToBeLoaded setHidden:NO];
        [loader stopAnimating];
        
        [imageToBeLoaded setHidden:NO];
        [mySuperView sendSubviewToBack:removingView];
        
        
        if (he>3) {
            if(he == 17 && orignalwidth == 580){
            
                [imageToBeLoaded setHidden:YES];
                [removingView setHidden:NO];
            }
            else if(he == 16 && orignalwidth == 16){
                [imageToBeLoaded setHidden:YES];
                [removingView setHidden:NO];
                
            }
            else{
                [imageToBeLoaded setHidden:NO];
                [removingView setHidden:YES];
            }
        }
        else{
            
            [imageToBeLoaded setHidden:YES];
        [removingView setHidden:NO];
        }
        
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSString *httpPart = [urlToLoad substringToIndex:2];
            NSURL *imageURL;
            
            if ([httpPart isEqualToString:@"//"]) {
                
                
                imageURL = [NSURL URLWithString:[@"http:" stringByAppendingString:urlToLoad]];
                
            }
            if ([httpPart isEqualToString:@"\"h"]) {
                
                imageURL = [NSURL URLWithString: [urlToLoad stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
                
            }
            else{
                imageURL = [NSURL URLWithString:urlToLoad];
            }
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            [FileManager
             saveFeedsImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                
                
                
                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                UIImage *image = imageToBeLoaded.image;
                
                
                double finalWidth = (image.size.width * 151.0)/image.size.height+25;
                double he = image.size.height;
                double orignalwidth = image.size.width;
                
                if (he >= 151) {
                    
                    UIImage *tmp = [FileManager scaleImage:image toSize:CGSizeMake(finalWidth, 151)];
                    imageToBeLoaded.image = tmp;
                    
                }
                else
                {
                    imageToBeLoaded.clipsToBounds = YES;
                    imageToBeLoaded.image = image;
                    
                }
                
                [imageToBeLoaded setHidden:NO];
                UIView *mySuperView = imageToBeLoaded.superview;
                [mySuperView sendSubviewToBack:imageToBeLoaded];
                
                [loader stopAnimating];
                
                
                [imageToBeLoaded setHidden:NO];
        
                [mySuperView sendSubviewToBack:removingView];
                [removingView setHidden:YES];
                

         //                       [removingView setHidden:YES];
                
                if (he>3) {
                    if(he == 17 && orignalwidth == 580){
                        
                        [imageToBeLoaded setHidden:YES];
                        [removingView setHidden:NO];
                    }
                    else if(he == 16 && orignalwidth == 16){
                        [imageToBeLoaded setHidden:YES];
                        [removingView setHidden:NO];
                        
                    }
                    
                    else{
                        [imageToBeLoaded setHidden:NO];
                        [removingView setHidden:YES];
                    }
                }//17 580
                else{
                    
                    [imageToBeLoaded setHidden:YES];
                    [removingView setHidden:NO];
                    
                }
                
                
                
            });
        });
        
        
    }
    
}

+(void)loadFeedsLogoImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader withFinalWidt:(int)width height:(int)height{
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if (!pathName) {
        
        return;
        
        
    }
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        
        
        UIImage *image = [FileManager getFeedsImage:pathName];

        [imageToBeLoaded setImage:image];
        
        [loader stopAnimating];
        imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[baseImageLink stringByAppendingString:urlToLoad]];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            [FileManager
             saveFeedsImageToDisk:imageData
             fileName:pathName];
            
            
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                
                
                

                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                UIImage *image = imageToBeLoaded.image;


                [imageToBeLoaded setImage:image];
                imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
                

            
                
            });
        });
        
        
    }
    
}


+(UIImage *)loadFeedsImageurl:(NSString *)urlToLoad
{
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        UIImage *image = [FileManager getFeedsImage:pathName];
    
        return image;
    }
    
    return nil;
    
}

+(void)loadWeathImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader{
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        
        
        UIImage *image = [FileManager getFeedsImage:pathName];
        imageToBeLoaded.image = [FileManager getFeedsImage:pathName];
        
        

            imageToBeLoaded.clipsToBounds = YES;
            
            imageToBeLoaded.image = image;
            
            //imageToBeLoaded.contentMode = UIViewContentModeCenter;
            

    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                return;
                
            }
            [FileManager
             saveFeedsImageToDisk:imageData
             fileName:pathName];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                [imageToBeLoaded setHidden:NO];

                
                
            });
        });
        
        
    }
    
    
}




+(UIImage *)getAssetImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Images"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}



+(BOOL )fileAssetImageExistsAtPath:(NSString *)directory withCountry:(NSString *)country{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Images"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(void)saveAssetImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName withCountry:(NSString *)country
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Images"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(UIImage *)loadCityVoiceImageFromurl:(NSString *)urlToLoad
{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetImageExistsAtPath:pathName withCountry:@""])
    {
        
        UIImage *tmp = [self getAssetImage:pathName];
        
        return tmp;
    }
    
    return nil;
    
}


+(void)loadAssetImageWithImageView:(UIImageView *)imageView
                             url:(NSString *)urlToLoad
           withComplitionHandler:(void(^)(void))completionHandler
              withFailureHandler:(void(^)(void))failHandler
                        withLoader:(UIActivityIndicatorView *)loader
{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetImageExistsAtPath:pathName withCountry:@""])
    {
        [loader stopAnimating];
        
        [imageView setImage:[self getAssetImage:pathName]];
        
        
        
        completionHandler();
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSURL *imageURL;
            
            if ([urlToLoad containsString:@"http"]) {
            
                imageURL = [NSURL URLWithString:urlToLoad];
            }
            else
                imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"image/"] stringByAppendingString:urlToLoad]];

            

            
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                failHandler();
                return;
                
            }
            
            [self saveAssetImageToDisk:imageData fileName:pathName withCountry:@""];
            [loader stopAnimating];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [imageView setImage:[self getAssetImage:pathName]];
                
                completionHandler();
                
                
            });
        });
    }
}
+(void)loadAssetImageWithCountry:(NSString *)country
                      url:(NSString *)urlToLoad
            withComplitionHandler:(void(^)(void))completionHandler
              withFailureHandler:(void(^)(void))failHandler assetId:(NSNumber *)assetId
{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    if ([FileManager fileAssetImageExistsAtPath:pathName withCountry:country])
    {
        
       completionHandler();
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
          

            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"image/"] stringByAppendingString:urlToLoad]];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
             
                failHandler();
                return;
                
            }
            
            [self saveAssetImageToDisk:imageData fileName:pathName withCountry:country];
            
            
            [Asset updateById:assetId isDownload:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
            
                completionHandler();
                
            });
        });
    }
}

+(void)loadScripterImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader withComplitionHandler:(void(^)(void))completionHandler
{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        
        
        UIImage *image = [FileManager getFeedsImage:pathName];
        imageToBeLoaded.image = [FileManager getFeedsImage:pathName];
        
        double he = image.size.height;
        
        double finalWidth = (image.size.width *
                             imageToBeLoaded.frame.size.height)/image.size.height;
        
        //imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
        
        if (imageToBeLoaded.frame.size.height >= he) {
            
            imageToBeLoaded.clipsToBounds = YES;
            
            imageToBeLoaded.image = image;
            
            imageToBeLoaded.contentMode = UIViewContentModeCenter;
            
        }
        else
        {
            
            UIImage *tmp = [FileManager scaleImage:image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];
            
            imageToBeLoaded.image = tmp;
            ///
            
            
            
        }
        
        
        UIView *mySuperView = imageToBeLoaded.superview;
        [mySuperView sendSubviewToBack:imageToBeLoaded];
        [imageToBeLoaded setHidden:NO];
        
        [loader stopAnimating];
        

    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                return;
                
            }
            [FileManager
             saveFeedsImageToDisk:imageData
             fileName:pathName];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                [imageToBeLoaded setHidden:NO];
                [loader stopAnimating];
                UIView *mySuperView = imageToBeLoaded.superview;
                [mySuperView sendSubviewToBack:imageToBeLoaded];
                [imageToBeLoaded setHidden:NO];
                [loader stopAnimating];
                
                
            });
        });
    }
}



+(void)loadFeedsImage : (UIImageView *)imageToBeLoaded
                       url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if ([FileManager fileFeedsExistsAtPath:pathName])
    {
        
     
        UIImage *image = [FileManager getFeedsImage:pathName];
        imageToBeLoaded.image = [FileManager getFeedsImage:pathName];
        
        double he = image.size.height;
        
        double finalWidth = (image.size.width *
                             imageToBeLoaded.frame.size.height)/image.size.height+25;
       
        imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
        
        if (imageToBeLoaded.frame.size.height >= he) {
        
            imageToBeLoaded.clipsToBounds = YES;
            
            imageToBeLoaded.image = image;
            
            imageToBeLoaded.contentMode = UIViewContentModeCenter;
            
        }
        else
        {
            
            UIImage *tmp = [FileManager scaleImage:image toSize:CGSizeMake(finalWidth, imageToBeLoaded.frame.size.height)];
            
            imageToBeLoaded.image = tmp;
            ///
        
        }

        
        UIView *mySuperView = imageToBeLoaded.superview;
        [mySuperView sendSubviewToBack:imageToBeLoaded];
        [imageToBeLoaded setHidden:NO];
        
        [loader stopAnimating];
    
    
        [mySuperView bringSubviewToFront:imageToBeLoaded];
        
        
        UIView *v1 = [mySuperView viewWithTag:33];
        UIView *v2 = [mySuperView viewWithTag:32];
        [mySuperView bringSubviewToFront:v1];
        [mySuperView bringSubviewToFront:v2];
    

        [loader removeFromSuperview];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                return;
                
            }
            [FileManager
             saveFeedsImageToDisk:imageData
             fileName:pathName];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                imageToBeLoaded.contentMode = UIViewContentModeScaleAspectFit;
                
                imageToBeLoaded.image = [UIImage imageWithData:imageData];
                [imageToBeLoaded setHidden:NO];
                [loader stopAnimating];
                UIView *mySuperView = imageToBeLoaded.superview;
                [mySuperView sendSubviewToBack:imageToBeLoaded];
                [imageToBeLoaded setHidden:NO];
                [loader stopAnimating];
                [mySuperView bringSubviewToFront:imageToBeLoaded];
        
                UIView *v1 = [mySuperView viewWithTag:33];
                UIView *v2 = [mySuperView viewWithTag:32];
                [mySuperView bringSubviewToFront:v1];
                [mySuperView bringSubviewToFront:v2];
                
[loader removeFromSuperview];
                
                
            });
        });
        
        
    }
}

+(BOOL )fileFeedsExistsAtPath:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Feeds"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(UIImage *)getFeedsImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Feeds"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}



+(void)saveFeedsImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Feeds"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

#pragma Background Images

#pragma mark Events

+(UIImage *)getBackgroundImage:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Background"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: dataPath];
    
    return graphImage;
    
}


+(BOOL )fileBackgroundExistsAtPath:(NSString *)directory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Background"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}


+(void)saveBackgroundImageToDisk :(NSData *)imageToSave fileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Background"];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}


+(BOOL)ifBackgroundImageExistsUrl:(NSString *)urlToLoad{
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    return [FileManager fileBackgroundExistsAtPath:pathName];
    
}


+(UIImage *)BackgroundFromUrl:(NSString *)urlToLoad{
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    return [FileManager getBackgroundImage:pathName];
    
}

+(void)loadBackgroundImage : (UIImageView *)imageToBeLoaded
                   url:(NSString *)urlToLoad loader:(UIActivityIndicatorView *)loader
      withComplitionHandler:(void(^)(void))completionHandler

{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    if ([FileManager fileBackgroundExistsAtPath:pathName])
    {
        [UIView transitionWithView:imageToBeLoaded
                          duration:1.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                            imageToBeLoaded.image = [FileManager getBackgroundImage:pathName];
        
                            
                            //[loader stopAnimating];
                            
                            
                            completionHandler();
                            
                            //self.imageView.image = toImage;
                        } completion:nil];
        
        [loader stopAnimating];
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            if(!imageData)
                return;
            
            [FileManager
             saveBackgroundImageToDisk:imageData
             fileName:pathName];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                
                
                [UIView transitionWithView:imageToBeLoaded
                                  duration:.0f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    imageToBeLoaded.image = [UIImage imageWithData:imageData];
                                    [loader stopAnimating];
                                    
                                    
                                    
                                    completionHandler();
                                    
                                    //self.imageView.image = toImage;
                                } completion:nil];

                

                
                
                
                
                
                
            });
        });
        
        
    }
}



+(BOOL )fileAssetAudioExistsAtPath:(NSString *)directory withCountry:(NSString *)country{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Audio"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(void)saveAssetAudioToDisk :(NSData *)imageToSave fileName:(NSString *)fileName withCountry:(NSString *)country
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Audio"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(NSString *)giveAudioPathAssetAudiofileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Audio"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    
    return dataPath;

    
}


+(void)getAssetAudioWithUrl:(NSString *)urlToLoad
            withComplitionHandler:(void(^)(NSString * path))completionHandler
         withFailureHandler:(void(^)(void))failHandler withAssetId:(NSNumber *)assetId
{
    
    if ([urlToLoad length] == 0) {
        return;
    }
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetAudioExistsAtPath:pathName withCountry:@""])
    {
        
        

        completionHandler([self giveAudioPathAssetAudiofileName:pathName]);
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"audio/"]
                                                    stringByAppendingString:urlToLoad]];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            
            
            
            if (!imageData) {
                
                failHandler();
                return;
            }
            
            [self saveAssetAudioToDisk:imageData fileName:pathName withCountry:@""];
            
            [Asset updateById:assetId isDownload:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
        completionHandler([self giveAudioPathAssetAudiofileName:pathName]);
            
                
                
            });
        });
    }
}


+(void)loadAssetAudioWithCountry : (NSString *)country
                              url:(NSString *)urlToLoad
            withComplitionHandler:(void(^)(void))completionHandler
               withFailureHandler:(void(^)(void))failHandler
withAssetId:(NSNumber *)assetId
{
    
    if ([urlToLoad length] == 0) {
        return;
    }
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetAudioExistsAtPath:pathName withCountry:country])
    {
        
        completionHandler();
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
           // NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"audio/"]
                                                stringByAppendingString:urlToLoad]];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                failHandler();
                return;
                
                
                
            }
            
            [self saveAssetAudioToDisk:imageData fileName:pathName withCountry:country];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                completionHandler();
                
                
            });
        });
    }
}

+(BOOL )fileAssetVideoExistsAtPath:(NSString *)directory withCountry:(NSString *)country{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Video"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(NSString *)giveVideoPathAssetAudiofileName:(NSString *)fileName
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Video"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    return dataPath;
}


+(void)saveAssetVideoToDisk :(NSData *)imageToSave fileName:(NSString *)fileName withCountry:(NSString *)country
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Video"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}


+(BOOL)doesExistVideoWithUrl:(NSString *)urlToLoad


{
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    return [FileManager fileAssetVideoExistsAtPath:pathName withCountry:@""];

}




+(void)getAssetVideoWithUrl:(NSString *)urlToLoad
      withComplitionHandler:(void(^)(NSString * path))completionHandler
         withFailureHandler:(void(^)(void))failHandler
                withAssetId:(NSNumber *)assetId


{
    
    if ([urlToLoad length] == 0) {
        return;
    }
    
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetVideoExistsAtPath:pathName withCountry:@""])
    {
        
        
        //completionHandler();
        completionHandler([self giveVideoPathAssetAudiofileName:pathName]);
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL;
            
            //NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            if ([urlToLoad containsString:@"http"]) {
                
                imageURL = [NSURL URLWithString:urlToLoad];
                
            }
            else
            imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"video/"]
                                                    stringByAppendingString:urlToLoad]];
            
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                failHandler();
                return;
            }
            
            [self saveAssetVideoToDisk:imageData fileName:pathName withCountry:@""];

            if (assetId) {
            [Asset updateById:assetId isDownload:YES];                
            }

            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                completionHandler([self giveVideoPathAssetAudiofileName:pathName]);
                
                
                
                
            });
        });
    }
}

+(void)loadAssetVideoWithCountry : (NSString *)country
                              url:(NSString *)urlToLoad
            withComplitionHandler:(void(^)(void))completionHandler
               withFailureHandler:(void(^)(void))failHandler
                      withAssetId:(NSNumber *)assetId

{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetVideoExistsAtPath:pathName withCountry:country])
    {
        
        completionHandler();
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"video/"] stringByAppendingString:urlToLoad]];
          
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                failHandler();
                return;
                
                
                
            }
            
            [self saveAssetVideoToDisk:imageData fileName:pathName withCountry:country];
            
            [Asset updateById:assetId isDownload:YES];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                completionHandler();
                
            });
        });
    }
}


+(BOOL )fileAssetOtherExistsAtPath:(NSString *)directory withCountry:(NSString *)country{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Other"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:directory];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    return fileExists;
}

+(void)saveAssetOtherToDisk :(NSData *)imageToSave fileName:(NSString *)fileName withCountry:(NSString *)country
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Other"]];
    NSString *dataPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&error]){
            
            NSLog(@"created directory");
            
        }
        else{
            
        }
    }
    
    NSString *savedImagePath = dataPath;
    
    [imageToSave writeToFile:savedImagePath atomically:YES];
    
}

+(void)loadAssetOtherWithCountry : (NSString *)country
                              url:(NSString *)urlToLoad
            withComplitionHandler:(void(^)(void))completionHandler
               withFailureHandler:(void(^)(void))failHandler
{
    
    if ([urlToLoad length] == 0) {
        return;
        
    }
    NSString *pathName = [urlToLoad
                          stringByReplacingOccurrencesOfString:@"/"
                          withString:@""];
    
    
    
    if ([FileManager fileAssetOtherExistsAtPath:pathName withCountry:country])
    {
        
        completionHandler();
        
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"others/"] stringByAppendingString:urlToLoad]];
            
            //NSURL *imageURL = [NSURL URLWithString:urlToLoad];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            if (!imageData) {
                
                failHandler();
                return;
                
                
                
            }
            
            [self saveAssetOtherToDisk:imageData fileName:pathName withCountry:country];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                completionHandler();
                
            });
        });
    }
}



@end
