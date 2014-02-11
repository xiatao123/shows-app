//
//  SearchMoviedbResult.h
//  showsApp
//
//  Created by Linkai Xi on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "SearchMoviedbModel.h"

@interface SearchMoviedbResult : JSONModel

@property (nonatomic, strong) NSMutableArray<SearchMoviedbModel>* results;
@end
