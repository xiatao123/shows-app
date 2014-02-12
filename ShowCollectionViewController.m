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

@interface ShowCollectionViewController ()

-(void)reload;

//@property (nonatomic, strong) SearchMoviedbResult* showResult;
@property (nonatomic, strong) ShowResult* showResult;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, readwrite, strong) REMenu *menu;
//@property (nonatomic, strong) NSDictionary *categories;

- (IBAction)onLogoutTap:(id)sender;
- (void)onSearchButton;

@end

@implementation ShowCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.categories = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:28], @"Action", [NSNumber numberWithInt:16], @"Animation", [NSNumber numberWithInt:35], @"Comedy", [NSNumber numberWithInt:18], @"Drama", [NSNumber numberWithInt:27], @"Horror", [NSNumber numberWithInt:53], @"Thriller", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    if (!self.categories){
//        self.categories = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:28], @"Action", [NSNumber numberWithInt:16], @"Animation", [NSNumber numberWithInt:35], @"Comedy", [NSNumber numberWithInt:18], @"Drama", [NSNumber numberWithInt:27], @"Horror", [NSNumber numberWithInt:53], @"Thriller", nil];
//    }
   // [GlobalShows globalCategorySingleton];
    
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearchButton)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self reload];
    
    __typeof (self) __weak weakSelf = self;
    if (REUIKitIsFlatMode()) {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    REMenuItem *popularItem = [[REMenuItem alloc] initWithTitle:@"Popular Shows"
                                                       subtitle:@"Popular TV Shows"
                                                          image:[UIImage imageNamed:@"Icon_Home"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [weakSelf loadPopular];
                                                         }];
    [menuItems addObject:popularItem];
    
    REMenuItem *topItem = [[REMenuItem alloc] initWithTitle:@"Top Shows"
                                                    subtitle:@"Top Rated TV Shows"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                         [weakSelf loadTopRated];
                                                     }];
    [menuItems addObject:topItem];
    
    int temp = 2;
    for(NSString *categoryName in [GlobalShows globalCategorySingleton]){
        NSNumber *categoryID = [[GlobalShows globalCategorySingleton] objectForKey:categoryName];
        REMenuItem *tempItem = [[REMenuItem alloc] initWithTitle: categoryName
                                                   subtitle:[NSString stringWithFormat: @"%@ Shows", categoryName]
                                                      image:[UIImage imageNamed:@"Icon_Home"]
                                           highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                        NSLog(@"Item: %@", item);
                                                        [weakSelf loadCategory:[categoryID intValue]];
                                                    }];
        tempItem.tag = temp++;
        [menuItems addObject:tempItem];
    }
    
    
    popularItem.tag = 0;
    topItem.tag = 1;
    
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
    //TODO
    return [self.showResult.shows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforItemAtIndexPath log");
    static NSString *CellIdentifier = @"ShowCell";
    ShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSLog(@"cell is null");
    }
    
    Show *show = self.showResult.shows[indexPath.row];
    NSLog(@"title is %@", show.name);
    cell.backgroundColor = [UIColor whiteColor];
    [cell.showsNameLabel setText:show.name];
    NSString* baseUrl = @"http://image.tmdb.org/t/p/w500";
    [cell.showsPosterImage setImageWithURL:[[NSURL alloc]initWithString: [baseUrl stringByAppendingString:show.poster_path]]];

    return cell;
}

-(void)reload{
    [YQL query:@"use 'store://CUxLN5g0Ad8rP9z9woUKyA' as popular; select * from popular;"
      callback:^(NSError *error, id response) {
          //NSLog(@"get response.result %@", [response valueForKeyPath:@"query.results.json"] );
          NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
          NSError *err = nil;
          //NSLog(@"%@",showJSON);
          self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
          [self.collectionView reloadData];
      }];
}

-(void)loadTopRated{
    [YQL query:@"use 'store://37O7tSnvbk37Zpl3Zeo2W0' as top; select * from top;"
      callback:^(NSError *error, id response) {
         NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
         NSError *err = nil;
         //NSLog(@"%@",showJSON);
         self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
         [self.collectionView reloadData];
     }];
}

-(void)loadPopular{
    [YQL query:@"use 'store://CUxLN5g0Ad8rP9z9woUKyA' as popular; select * from popular;"
      callback:^(NSError *error, id response) {
          NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
          NSError *err = nil;
          //NSLog(@"%@",showJSON);
          self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
          [self.collectionView reloadData];
      }];
}

-(void)loadCategory:(int)categoryID{
    [YQL query:[NSString stringWithFormat:@"use 'store://qgc6p6Z7WGrJWXs9Mn4LFe' as category; select * from category where with_genres=%d;", categoryID]
      callback:^(NSError *error, id response) {
          NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json"] ;
          NSError *err = nil;
          //NSLog(@"%@",showJSON);
          self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
          [self.collectionView reloadData];
      }];  
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
    Show *show = [self.showResult.shows objectAtIndex:indexPath.row];
    controller.tmdb_id = show.id;
}
@end
