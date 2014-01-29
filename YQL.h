//
//  YQL.h
//  showsApp
//
//  Created by Daniel Park on 1/28/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface YQL : NSObject
+ (NSArray *) showTables: (void (^)(NSError *error, id response))callback;
+ (void) select:(NSString *)field from:(NSString*)table where:(NSDictionary *)filters callback:(void (^)(NSError *, id))callback;
- (void) select:(NSString *)field from:(NSString*)table where:(NSDictionary *)filters callback:(void (^)(NSError *, id))callback;
+ (YQL *) use:(NSDictionary *)use;
@end
