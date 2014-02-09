//
//  ShowCollectionViewController.h
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface ShowCollectionViewController : UICollectionViewController

@property (nonatomic, readonly, strong) REMenu *menu;

- (void)toggleMenu;

@end
