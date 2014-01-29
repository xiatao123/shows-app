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

@interface ViewController ()
- (IBAction)onLoginTapped:(UIButton *)sender;
@property (nonatomic, strong) AFOAuth1Client *yahoo;

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    NSString *key = @"";
    NSString *secret = @"";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"view did load");
    self.yahoo = [[AFOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/"] key:key secret:secret];
    /*
    [YQL showTables:^(NSError *error, id response) {
        // NSLog(@"got response %@", response);
    }];
     */
    
    [[YQL use:@{@"store://lsri0aFyNSXQsSFK0jYL9F": @"tvdb" }]
     select:@"*" from:@"tvdb" where:@{ @"date" : @"20140114" } callback:^(NSError *error, id response) {
         NSLog(@"got resposne %@", response);
     }
     ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginTapped:(UIButton *)sender {
    NSLog(@"login button tapped");
    [self.yahoo authorizeUsingOAuthWithRequestTokenPath:@"get_request_token" userAuthorizationPath:@"request_auth" callbackURL:[NSURL URLWithString:@"yahoo://success"] accessTokenPath:@"get_token" accessMethod:@"POST" scope:nil success:^(AFOAuth1Token *access_token, id request){
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"failure");
        NSLog(@"%@", error);
    }];
}
@end
