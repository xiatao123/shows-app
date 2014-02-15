//
//  GlobalMethod.h
//  showsApp
//
//  Created by Linkai Xi on 2/15/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject

+ (NSURL*)buildImageURL:(NSString*)file_path  size:(NSString*)size;
+ (UIImage*)getImagePlaceholder;

@end
