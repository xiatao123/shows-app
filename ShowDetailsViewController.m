//
//  ShowDetailsViewController.m
//  showsApp
//
//  Created by Daniel Park on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "YQL.h"
#import "UIImageView+AFNetworking.h"

@interface ShowDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showOverview;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;

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
    [[YQL use:@{@"https://raw.github.com/ios-class/yshows-tables/master/tmdb.tv.id.xml": @"identity" }] select:@"*" from:@"identity" where:@{ @"id" : [NSNumber numberWithInt:self.tmdb_id] } callback:^(NSError *error, id response) {
        
        NSObject *results = [response valueForKeyPath:@"query.results.json"];
        self.title = [results valueForKeyPath:@"original_name"];
        self.showOverview.text = [results valueForKey:@"overview"];
        NSString *backdrop_url = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500/%@", [results valueForKey:@"backdrop_path"]];
        [self.showImage setImageWithURL:[NSURL URLWithString:backdrop_url]];
    }];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
