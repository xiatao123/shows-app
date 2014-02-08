//
//  SearchMoviedbModel.h
//  showsApp
//
//  Created by Linkai Xi on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h";

@protocol SearchMoviedbModel


@end

@interface SearchMoviedbModel : JSONModel

@property (nonatomic, strong) NSURL* backdrop_path;
@property (nonatomic, assign) int id;
@property (nonatomic, strong) NSString* original_name;
@property (nonatomic, strong) NSString* first_air_date;
@property (nonatomic, strong) NSURL* poster_path;
@property (nonatomic, assign) float popularity;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) float vote_average;
@property (nonatomic, assign) int vote_count;

@end
