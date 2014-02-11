//
//  Show.h
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Episode.h"

@protocol Show
@end

@interface Show : JSONModel

@property (nonatomic, strong) Episode<Optional>* episode;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* original_name;
@property (nonatomic, assign) float vote_average;
@property (nonatomic, assign) int vote_count;
@property (nonatomic, strong) NSString<Optional>* first_air_date;
@property (nonatomic, strong) NSString<Optional>* air_time;
@property (nonatomic, strong) NSString<Optional>* overview;
@property (nonatomic, strong) NSString<Optional>* imdb_id;
@property (nonatomic, strong) NSString<Optional>* tvdb_id;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* poster_path;
@property (nonatomic, strong) NSString* backdrop_path;
@property (nonatomic, assign) float popularity;

+(BOOL)propertyIsOptional:(NSString *)propertyName;

@end



