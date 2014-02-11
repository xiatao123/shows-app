//
//  ShowResult.m
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ShowResult.h"

@implementation ShowResult


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"results":@"shows"}];
}

@end
