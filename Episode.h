//
//  Episode.h
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Episode : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int episode_number;
@property (nonatomic, strong) NSString* FirstAired;
@property (nonatomic, strong) NSString* overview;
@property (nonatomic, assign) int season_number;
@property (nonatomic, strong) NSURL* poster;
@property (nonatomic, strong) NSString* Airs_Time;

+(BOOL)propertyIsOptional:(NSString *)propertyName;

@end
