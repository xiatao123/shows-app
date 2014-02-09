//
//  ShowDetailsViewController.m
//  showsApp
//
//  Created by Daniel Park on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "YQL.h"

@interface ShowDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;

@end

@implementation ShowDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    [[YQL use:@{@"https://raw.github.com/ios-class/yshows-tables/master/tmdb.tv.id.xml": @"identity" }] select:@"*" from:@"identity" where:@{ @"id" : @1399 } callback:^(NSError *error, id response) {
        
        NSLog(@"data is %@", response);
        /*
        NSArray * array = [response valueForKeyPath:@"query.results.json.tv_results"];
        NSObject *show = array[0];
        self.showTitleLabel.text = [show valueForKey:@"name"];
         */
    }];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
