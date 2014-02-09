//
//  SearchViewController.m
//  showsApp
//
//  Created by Linkai Xi on 2/5/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "SearchViewController.h"
#import "YQL.h"

@interface SearchViewController ()


//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) UISearchBar *mySearchBar;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//        self.mySearchBar.backgroundColor = [UIColor redColor];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[YQL use:@{@"store://pgdGby6VuyucfR52SFZ1wb": @"search" }] select:@"*" from:@"search" where:@{ @"query" : @"breaking" } callback:^(NSError *error, id response) {}];
    
    NSLog(@"search view load");
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchDisplay delegate
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}

- (BOOL) searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return NO;
}

#pragma mark - UISearchBar delegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}

- (void)getSearchResults:(NSString *)searchText startingFrom:(int)start {
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

@end
