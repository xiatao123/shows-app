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

-(void)removeShowsWithoutPoster{
    NSMutableArray* removeShowArray = [NSMutableArray array];
    for (Show* show in self.shows) {
        if (show.poster_path == NULL){
            [removeShowArray addObject:show];
        }
    }
    for(Show* show in removeShowArray){
        [self.shows removeObject:show];
    }
}

@end
