//
//  ShowResult.h
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Show.h"

//@protocol Show
//@end

@interface ShowResult : JSONModel

@property (nonatomic, strong) NSArray<Show>* shows;

@end
