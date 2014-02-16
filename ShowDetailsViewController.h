//
//  ShowDetailsViewController.h
//  showsApp
//
//  Created by Daniel Park on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDetailsViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSString * tmdb_id;
@property (nonatomic, strong) NSMutableArray* showArrayBucket;
@end
