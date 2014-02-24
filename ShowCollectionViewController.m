//
//  ShowCollectionViewController.m
//  showsApp
//
//  Created by Linkai Xi on 1/29/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "ShowCollectionViewController.h"
#import "SearchViewController.h"
#import "ShowCell.h"
#import "YQL.h"
#import "ShowResult.h"
#import "Show.h"
#import "ShowDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "GlobalShows.h"
#import "GlobalMethod.h"
#import "LocalStorage.h"
#import "Toast+UIView.h"
#import <Parse/Parse.h>

@interface ShowCollectionViewController ()

-(void)loadTopRated;
-(void)loadPopular;
-(void)loadCategory:(int)categoryID categoryName:(NSString *)categoryName;


@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, readwrite, strong) REMenu *menu;
@property (nonatomic, strong) NSString* bucketKey;
@property (nonatomic, strong) NSMutableArray* showArrayBucket;


- (IBAction)onLogoutTap:(id)sender;
- (void)onSearchButton;

@end

@implementation ShowCollectionViewController

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
	// Do any additional setup after loading the view.
    
    self.bucketKey = @"";
    self.showArrayBucket = [NSMutableArray array];
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearchButton)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    __typeof (self) __weak weakSelf = self;
    [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor blackColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Adding a border on navigation bar
    [self addNavBorder];
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    int tag = 0;
    
    
    NSString *guid = [(NSDictionary *)[LocalStorage read:@"current_user"] objectForKey:@"guid"];

    if(guid){
        REMenuItem *favoriteItem = [[REMenuItem alloc] initWithTitle:@"Favorite Shows"
                                                           subtitle:@"Favorite TV Shows"
                                                              image:[UIImage imageNamed:@"Icon_Home"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 [weakSelf loadFavorite:guid];
                                                             }];
        
        [menuItems addObject:favoriteItem];
        favoriteItem.tag = tag++;
    }

    
    
    REMenuItem *popularItem = [[REMenuItem alloc] initWithTitle:@"Popular Shows"
                                                       subtitle:@"Popular TV Shows"
                                                          image:[UIImage imageNamed:@"Icon_Home"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [weakSelf loadPopular];
                                                         }];
    [menuItems addObject:popularItem];
    popularItem.tag = tag++;
    
    REMenuItem *topItem = [[REMenuItem alloc] initWithTitle:@"Top Shows"
                                                    subtitle:@"Top Rated TV Shows"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         [weakSelf loadTopRated];
                                                     }];
    [menuItems addObject:topItem];
    topItem.tag = tag++;

    for(NSString *categoryName in [GlobalShows category]){
        NSNumber *categoryID = [[GlobalShows category] objectForKey:categoryName];
        REMenuItem *tempItem = [[REMenuItem alloc] initWithTitle: categoryName
                                                   subtitle:[NSString stringWithFormat: @"%@ Shows", categoryName]
                                                      image:[UIImage imageNamed:@"Icon_Home"]
                                           highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        [weakSelf loadCategory:[categoryID intValue] categoryName:categoryName];
                                                    }];
        [menuItems addObject:tempItem];
        tempItem.tag = tag++;
    }
    
    REMenuItem *logoutItem = [[REMenuItem alloc] initWithTitle:@"Log Out"
                                                   subtitle:@""
                                                      image:[UIImage imageNamed:@"Icon_Home"]
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         [weakSelf logout];
                                                     }];
    [menuItems addObject:logoutItem];
    logoutItem.tag = tag++;

    self.menu = [[REMenu alloc] initWithItems:menuItems];
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu)];
    
    if(guid){
        [self loadFavorite:guid];
    }else{
        [self loadPopular];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view data source

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"numberOfInSection");
    if(self.bucketKey!= NULL && self.bucketKey.length !=0 ){
        [self.showArrayBucket removeAllObjects];
        NSArray *keyBucket = [[GlobalShows globalTriageBucket]objectForKey:self.bucketKey];
        for(NSString *key in keyBucket){
            Show* show = [[GlobalShows globalShowsSingleton]objectForKey:key];
            [self.showArrayBucket addObject:show];
        }
        return self.showArrayBucket.count;
    }
    else return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellforItemAtIndexPath log");
    static NSString *CellIdentifier = @"ShowCell";
    ShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"cell is null");
    }
    if (self.bucketKey!= NULL && self.bucketKey.length !=0 ) {
        Show* show = self.showArrayBucket[indexPath.row];
        [cell.showsNameLabel setText:show.name];
        [cell.showsPosterImage setImageWithURL:[GlobalMethod buildImageURL:show.poster_path size:@"w500"] placeholderImage:[GlobalMethod getImagePlaceholder]];
    }else{
    }
    
    return cell;
}

-(void) viewWillAppear:(BOOL)animated{
    //Adding a border on navigation bar
    [self addNavBorder];
}

-(void)loadFavorite:(NSString*)guid{
    self.bucketKey = @"Favorite";
    
    [self setNavTitle:self.bucketKey];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"guid" equalTo:guid];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *bucket = [[GlobalShows globalTriageBucket] objectForKey:self.bucketKey];
        [bucket removeAllObjects];

        for(PFObject *object in objects){
            NSString *json = object[@"json"];
            NSError *err = nil;
            Show* show = [[Show alloc] initWithString:json error:&err];
            [bucket addObject:show.id];
            [[GlobalShows globalShowsSingleton] setValue:show forKey:show.id];
        }
        if(bucket.count>0){
            [self.collectionView reloadData];
        }else{
            [self loadPopular];
            UILabel *messagLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
            [messagLable setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)]; // autoresizing masks are respected on custom views
            [messagLable setBackgroundColor:[UIColor orangeColor]];
            messagLable.text = @" Oops! Your favorite list is empty ";
            
            [self.view showToast:messagLable
                        duration:3.0
                        position:@"center"
             ];
        }
    }];

}

-(void)loadTopRated{
    self.bucketKey = @"Top";
    
    [self setNavTitle:self.bucketKey];

    NSArray* keyBucket = [[GlobalShows globalTriageBucket]objectForKey:self.bucketKey];
    if (keyBucket.count != 0) {
        //NSLog(@"count!=0!");
        [self.collectionView reloadData];
    }else{
        [YQL query:@"use 'store://37O7tSnvbk37Zpl3Zeo2W0' as top; select * from top;"
          callback:^(NSError *error, id response) {
              NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
              NSError *err = nil;
              //NSLog(@"%@",showJSON);
              ShowResult* showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
              [showResult removeShowsWithoutPoster];
              NSMutableArray *bucket = [[GlobalShows globalTriageBucket] objectForKey:self.bucketKey];
              for(Show* show in showResult.shows){
                  [bucket addObject:show.id];
                  [[GlobalShows globalShowsSingleton] setValue:show forKey:show.id];
              }
              [self.collectionView reloadData];
          }];
    }
}

-(void)loadPopular{
    self.bucketKey = @"Popular";
    
    [self setNavTitle:self.bucketKey];
    
    NSArray* keyBucket = [[GlobalShows globalTriageBucket]objectForKey:self.bucketKey];
    if (keyBucket.count != 0) {
        //NSLog(@"count!=0!");
        [self.collectionView reloadData];
    }else{
        [YQL query:@"use 'store://CUxLN5g0Ad8rP9z9woUKyA' as popular; select * from popular;"
          callback:^(NSError *error, id response) {
              NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
              NSError *err = nil;
              //NSLog(@"%@",showJSON);
              ShowResult* showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
              [showResult removeShowsWithoutPoster];
              NSMutableArray *bucket = [[GlobalShows globalTriageBucket] objectForKey:self.bucketKey];
              for(Show* show in showResult.shows){
                  [bucket addObject:show.id];
                  [[GlobalShows globalShowsSingleton] setValue:show forKey:show.id];
              }
              [self.collectionView reloadData];
          }];
    }
}

-(void)loadCategory:(int)categoryID categoryName:(NSString *)categoryName{
    self.bucketKey = categoryName;
    
    [self setNavTitle:categoryName];

    NSArray* keyBucket = [[GlobalShows globalTriageBucket]objectForKey:categoryName];
    if (keyBucket.count != 0) {
        //NSLog(@"count!=0!");
        [self.collectionView reloadData];
    }
    else{
        [YQL query:[NSString stringWithFormat:@"use 'store://qgc6p6Z7WGrJWXs9Mn4LFe' as category; select * from category where with_genres=%d;", categoryID]
          callback:^(NSError *error, id response) {
              NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
              NSError *err = nil;
              //NSLog(@"%@",showJSON);
              //self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
              ShowResult* showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
              [showResult removeShowsWithoutPoster];
              NSMutableArray *bucket = [[GlobalShows globalTriageBucket] objectForKey:categoryName];
              for(Show* show in showResult.shows){
                  [bucket addObject:show.id];
                  [[GlobalShows globalShowsSingleton] setValue:show forKey:show.id];
              }
              [self.collectionView reloadData];
          }];  

    }
}

- (IBAction)onLogoutTap:(id)sender {
    NSLog(@"logout tapped");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onSearchButton{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    ShowDetailsViewController *controller = segue.destinationViewController;
    Show *show = [self.showArrayBucket objectAtIndex:indexPath.row];
    controller.tmdb_id = show.id;
    controller.bucketKey = self.bucketKey;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //Adding a border on navigation bar
    [self addNavBorder];
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

-(void)setNavTitle:(NSString*) title{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.shadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.25f];
    titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

-(void)logout{
    
}

@end
