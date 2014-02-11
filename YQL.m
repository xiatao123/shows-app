//
//  YQL.m
//  showsApp
//
//  Created by Daniel Park on 1/28/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "YQL.h"
#import "NSString+UrlEncode.h"
#define YQL_URL @"http://query.yahooapis.com/v1/public/yql?format=json&diagnostics=true&q="

@interface YQL ()
@property (nonatomic, strong) NSString *use;
@end
@implementation YQL

- (id) initWithUse:(NSDictionary *)use {
    self = [super init];
    if (self) {
        NSString *key;
        NSMutableArray *uses = [[NSMutableArray alloc] init];
        for(key in use) {
            [uses addObject:[NSString stringWithFormat:@"use '%@' as %@; ", key, [use objectForKey:key]]];
        }
        NSLog(@"constructed use %@", uses);
        self.use = [uses componentsJoinedByString:@""];
    }
    return self;
}

+ (void) query:(NSString *)statement callback:(void (^)(NSError *, id))callback {
    
    NSString *q = [statement urlEncode];
    NSURL *url = [NSURL URLWithString:[YQL_URL stringByAppendingString:q]];
    NSLog(@"final url is %@",  url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[AFJSONRequestOperation
      JSONRequestOperationWithRequest:request
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
          callback(nil, JSON);
      }
      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          callback(error, JSON);
      }
    ]start];
}

+ (NSArray *)showTables:(void (^)(NSError *, id))callback {
    [YQL query:@"show tables" callback:callback];
    return nil;
}

+ (void) select:(NSString *)field from:(NSString*)table where:(NSDictionary *)filters callback:(void (^)(NSError *, id))callback {
    
    NSString *key;
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSString *statement;
    
    if ([filters count] > 0) {
        for (key in filters) {
            [params addObject:[NSString stringWithFormat:@"%@='%@'", key, [filters objectForKey:key]]];
        }
        statement = [NSString stringWithFormat:@"select %@ from %@ where %@", field, table, [params componentsJoinedByString:@" and "]];
    }
    else {
        statement = [NSString stringWithFormat:@"select %@ from %@", field, table];
    }
    
    [YQL query:statement callback:callback];
}

+ (YQL *)use:(NSDictionary *)uses {
    return [[YQL alloc] initWithUse:uses];
}

- (void) select:(NSString *)field from:(NSString *)table where:(NSDictionary *)filters callback:(void (^)(NSError *, id))callback {
       NSString *key;
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSString *statement;
    
    if ([filters count] > 0) {
        for (key in filters) {
            [params addObject:[NSString stringWithFormat:@"%@=\'%@\'", key, [filters objectForKey:key]]];
        }
        statement = [NSString stringWithFormat:@"select %@ from %@ where %@", field, table, [params componentsJoinedByString:@" and "]];
    }
    else {
        statement = [NSString stringWithFormat:@"select %@ from %@", field, table];
    }
    
    if (self.use) {
        statement = [self.use stringByAppendingString:statement];
    }
    
    NSLog(@"statement is %@", statement);
    
    [YQL query:statement callback:callback];
}

@end
