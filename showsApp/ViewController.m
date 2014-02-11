//
//  ViewController.m
//  showsApp
//
//  Created by Daniel Park on 1/22/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ViewController.h"
#import "AFOAuth1Client.h"
#import "YQL.h"
#import "Show.h"
#import "ShowResult.h"
//#import "SearchMoviedbResult.h"
//#import "SearchMoviedbModel.h"


@interface ViewController ()
- (IBAction)onLoginTapped:(UIButton *)sender;
@property (nonatomic, strong) AFOAuth1Client *yahoo;
@property (nonatomic, strong) NSUserDefaults * defaults;
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    NSString *key = @"dj0yJmk9aks5ZHdkNzcxZ2dFJmQ9WVdrOVYwUnNPR0pRTkdVbWNHbzlPRFEzTWpVNE5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PWVl";
    NSString *secret = @"1867229fe956948e06b3d2958a6fe973ab052c4e";
    
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"view did load");
    self.yahoo = [[AFOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/"] key:key secret:secret];
    /*
    [YQL showTables:^(NSError *error, id response) {
        // NSLog(@"got response %@", response);
    }];
     */
    [YQL query:@"use 'store://CUxLN5g0Ad8rP9z9woUKyA' as popular; select * from popular;"
      callback:^(NSError *error, id response) {
         
         //NSLog(@"got resposne %@", response);
         NSLog(@"get response.result %@", [response valueForKeyPath:@"query.results.json"] );
         NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
         NSError *err = nil;
         //NSLog(@"%@",showJSON);
         //Show *show = [[Show alloc]initWithDictionary:showJSON error:&err];
//         SearchMoviedbResult* showResult = [[SearchMoviedbResult alloc] initWithDictionary:showJSON error:&err];
//         SearchMoviedbModel *show = [showResult.results objectAtIndex:0];
         //NSLog(@"0 show tvdb_id is %i", show.id);
     }
    ];
    
    NSData * data = [[self defaults] objectForKey:@"accessToken"];
    if (data) {
        AFOAuth1Token * accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];;
        [self performSegueWithIdentifier:@"goToHome" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginTapped:(UIButton *)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.yahoo
     authorizeUsingOAuthWithRequestTokenPath:@"get_request_token"
     userAuthorizationPath:@"request_auth"
     callbackURL:[NSURL URLWithString:@"yshows://success"]
     accessTokenPath:@"get_token"
     accessMethod:@"POST"
     scope:nil success:^(AFOAuth1Token *accessToken, id request){
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
         // encode access token
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
         
         // save to NSUserDefaults
         [[self defaults] setObject:data forKey:@"accessToken"];
         [[self defaults] synchronize];
         
         [self performSegueWithIdentifier:@"goToHome" sender:self];
     }
     failure:^(NSError *error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         // popup for error
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
     }
    ];
}
@end
