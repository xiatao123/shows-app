//
//  GlobalShows.h
//  showsApp
//
//  Created by Linkai Xi on 2/11/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalShows : NSObject

+ (NSDictionary *)globalShowsSingleton;
+ (NSDictionary *)globalCategory;
+ (NSDictionary *)globalTriageBucket;


@end
