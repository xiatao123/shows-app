//
//  LocalStorage.h
//  showsApp
//
//  Created by Daniel Park on 2/10/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject
+ (void) create: (id)key value:(id)value;
+ (id)   read:   (id)key;
+ (void) update: (id)key value:(id)value;
+ (void) delete: (id)key;
@end
