//
//  GlobalMethod.m
//  showsApp
//
//  Created by Linkai Xi on 2/15/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod


+ (NSURL*)buildImageURL:(NSString *)file_path size:(NSString *)size{
    if (file_path==NULL) {
        return NULL;
    }
    static NSString *base_url = @"http://image.tmdb.org/t/p/";
    NSString* baseAndSize = [base_url stringByAppendingString:size];
    NSString* fullString = [baseAndSize stringByAppendingString:file_path];
    return [[NSURL alloc]initWithString:fullString];
}

+ (UIImage*)getImagePlaceholder{
    
    static dispatch_once_t once;
    static UIImage* imagePlaceholder;
    dispatch_once(&once, ^{
        imagePlaceholder = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://cdn0.iconfinder.com/data/icons/elite-emoticons/512/not-excited-128.png"]]];
    });
    
    return imagePlaceholder;
}

@end
