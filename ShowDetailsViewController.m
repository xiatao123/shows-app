//
//  ShowDetailsViewController.m
//  showsApp
//
//  Created by Daniel Park on 2/7/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ShowDetailsViewController.h"
#import "ShowCollectionViewController.h"
#import "YQL.h"
#import "Show.h"
#import "UIImageView+AFNetworking.h"
#import "LocalStorage.h"
#import <Parse/Parse.h>
#import "GlobalShows.h"

@interface ShowDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) Show *show;
@property (weak, nonatomic) IBOutlet UILabel *showOverview;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) PFObject *favorite;
@property (assign, nonatomic) bool is_favorited;
- (IBAction)onFavTap:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favButton;


- (IBAction)onRightSwipeGesture:(id)sender;


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

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize = CGSizeMake(320, 5000);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Show* show = [[GlobalShows globalShowsSingleton]objectForKey:self.tmdb_id];
    
    [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor blackColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Adding a border on navigation bar
    [self addNavBorder];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [show valueForKey:@"name"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f];
    titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

    // ((UIScrollView *)self.view).contentSize = CGSizeMake(320, 5000);
    self.scrollView.contentSize = CGSizeMake(320, 5000);
    
    self.show = [[GlobalShows globalShowsSingleton]objectForKey:self.tmdb_id];
    self.title = [self.show valueForKey:@"name"];
    NSString *backdrop_url = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500/%@", [self.show valueForKey:@"backdrop_path"]];
    [self.showImage setImageWithURL:[NSURL URLWithString:backdrop_url]];
    
    [[YQL use:@{@"https://raw.github.com/ios-class/yshows-tables/master/tmdb.tv.id.xml": @"identity" }] select:@"*" from:@"identity" where:@{ @"id" : self.tmdb_id } callback:^(NSError *error, id response) {
        
        NSObject *results = [response valueForKeyPath:@"query.results.json"];
        self.showOverview.text = [results valueForKey:@"overview"];
    }];
    
    NSString *guid = [(NSDictionary *)[LocalStorage read:@"current_user"] objectForKey:@"guid"];
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"guid" equalTo:guid];
    [query whereKey:@"tmdb_id" equalTo:self.tmdb_id];
    [self.favButton setEnabled:NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"got objects %d", [objects count]);
        if ([objects count] == 1) {
            self.favorite = [objects objectAtIndex:0];
            self.favButton.title = @"Unfavorite";
            self.is_favorited = true;
        }
        [self.favButton setEnabled:YES];
    }];
    
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFavTap:(UIBarButtonItem *)sender {
    NSString *guid = [(NSDictionary *)[LocalStorage read:@"current_user"] objectForKey:@"guid"];
    
    [self.favButton setEnabled:NO];
    if (self.is_favorited) {
        [self.favorite deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.favorite = nil;
            self.is_favorited = false;
            self.favButton.title = @"Favorite";
            [self.favButton setEnabled:YES];
        }];
    }
    else {
        PFObject *testObject = [PFObject objectWithClassName:@"Favorite"];
        testObject[@"guid"] = guid;
        testObject[@"tmdb_id"] = self.tmdb_id;
        testObject[@"json"] = [self.show toJSONString];
        [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.favorite = testObject;
            self.is_favorited = true;
            self.favButton.title = @"Unfavorite";
            [self.favButton setEnabled:YES];
        }];
    }
}

-(void)addNavBorder{
    int borderID = 101;
    UINavigationBar* navBar = self.navigationController.navigationBar;
    for(UIView* view in self.navigationController.navigationBar.subviews){
        if ([view isKindOfClass:[UIView class]]&&view.tag==borderID){
            [view removeFromSuperview];
        }
    }
    
    int borderSize = 1;
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navBar.frame.size.height-borderSize,navBar.frame.size.width, borderSize)];
    navBorder.tag = borderID;
    [navBorder setBackgroundColor:[UIColor darkGrayColor]];
    [self.navigationController.navigationBar addSubview:navBorder];
}

- (IBAction)onRightSwipeGesture:(id)sender {
    NSLog(@"swipe right!");
    int index = 0;
    for(Show* show in self.showArrayBucket){
        if(show.id == self.tmdb_id){
            if([self.showArrayBucket objectAtIndex:(index+1)] != NULL){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ShowDetailsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];
                [self.navigationController pushViewController:svc animated:YES];
                Show* showNext = [self.showArrayBucket objectAtIndex:(index+1)];
                svc.tmdb_id = showNext.id;
                svc.showArrayBucket = self.showArrayBucket;
            }
            break;
        }
        index++;
    }
}
@end
