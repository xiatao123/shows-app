//
//  GlobalShows.m
//  showsApp
//
//  Created by Linkai Xi on 2/11/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "GlobalShows.h"

@implementation GlobalShows

+ (NSDictionary *)globalShowsSingleton{
    static dispatch_once_t once;
    static NSMutableDictionary *instance;
    dispatch_once(&once, ^{
        instance = [[NSMutableDictionary alloc]init];
    });
    
    return instance;
}

+ (NSDictionary *)globalCategory{
    static dispatch_once_t once;
    static NSDictionary *instance;
    dispatch_once(&once, ^{
        instance = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:28], @"Action", [NSNumber numberWithInt:16], @"Animation", [NSNumber numberWithInt:35], @"Comedy", [NSNumber numberWithInt:18], @"Drama", [NSNumber numberWithInt:27], @"Horror", [NSNumber numberWithInt:53], @"Thriller", nil];
    });
    
    return instance;
}

+ (NSDictionary *)globalTriageBucket{
    static dispatch_once_t once;
    static NSMutableDictionary *instance;
    dispatch_once(&once, ^{
        instance = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSMutableArray alloc]init], @"Action", [[NSMutableArray alloc]init], @"Animation", [[NSMutableArray alloc]init], @"Comedy", [[NSMutableArray alloc]init], @"Drama", [[NSMutableArray alloc]init], @"Horror", [[NSMutableArray alloc]init], @"Thriller", nil];
    });
    
    return instance;
}


@end
