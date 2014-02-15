//
//  LocalStorage.m
//  showsApp
//
//  Created by Daniel Park on 2/10/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "LocalStorage.h"

@implementation LocalStorage

+ (void)create:(id)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)read:(id)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)update:(id)key value:(id)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)delete:(id)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
