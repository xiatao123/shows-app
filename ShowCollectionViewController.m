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

@interface ShowCollectionViewController ()

-(void)reload;

@property (nonatomic, strong) ShowResult* showResult;
@property (nonatomic, strong) UIBarButtonItem *searchButton;
@property (nonatomic, readwrite, strong) REMenu *menu;


- (IBAction)onLogoutTap:(id)sender;
- (void)onSearchButton;

@end

@implementation ShowCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onSearchButton)];
    
    self.navigationItem.rightBarButtonItem = self.searchButton;
    
    [self reload];
    //UINib *showsNib = [UINib nibWithNibName:@"ShowCell" bundle:nil];
    // [self.collectionView registerClass:[ShowCell class] forCellWithReuseIdentifier:@"ShowCell"];

    
    __typeof (self) __weak weakSelf = self;
    if (REUIKitIsFlatMode()) {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                    subtitle:@"Return to Home Screen"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:nil];
    
    REMenuItem *topItem = [[REMenuItem alloc] initWithTitle:@"Top Shows"
                                                    subtitle:@"Top Rated TV Shows"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"Item: %@", item);
                                                         [weakSelf reload];
                                                     }];

    
    homeItem.tag = 0;
    topItem.tag = 1;
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, topItem]];
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
    static NSString *CellIdentifier = @"ShowCell";
    ShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //if(cell==nil){
    //    cell = [[ShowsCell alloc] initwithStyle: UICollectionViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //}
    
    if (cell == nil) {
        NSLog(@"cell is null");
    }
    
    Show *show = self.showResult.shows[indexPath.row];
    NSLog(@"title is %@", show.name);
    cell.backgroundColor = [UIColor whiteColor];
    [cell.showsNameLabel setText:show.name];
    [cell.showsPosterImage setImageWithURL:show.poster_path];

    return cell;
}

-(void)reload{
    [[YQL use:@{@"store://CUxLN5g0Ad8rP9z9woUKyA": @"tvdb" }]
      select:@"*"
      from:@"tvdb"
      callback:^(NSError *error, id response) {
         
         //NSLog(@"got resposne %@", response);
         // NSLog(@"get response.result %@", [response valueForKeyPath:@"query.results.results"] );
         NSDictionary *showJSON = [response valueForKeyPath:@"query.results.results"] ;
         NSError *err = nil;
         //NSLog(@"%@",showJSON);
         //Show *show = [[Show alloc]initWithDictionary:showJSON error:&err];
         self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
         Show *show = [self.showResult.shows objectAtIndex:0];
         NSLog(@"0 show name %@", show.name);
         [self.collectionView reloadData];
     }
     ];
}

-(void)loadPopular{
    [[YQL use:@{@"store://CUxLN5g0Ad8rP9z9woUKyA": @"popular" }]
     select:@"*"
     from:@"popular"
     callback:^(NSError *error, id response) {
        //NSLog(@"got resposne %@", response);
        // NSLog(@"get response.result %@", [response valueForKeyPath:@"query.results.results"] );
         NSDictionary *showJSON = [response valueForKeyPath:@"query.results.json.results"] ;
         NSError *err = nil;
         NSLog(@"%@",showJSON);
             //Show *show = [[Show alloc]initWithDictionary:showJSON error:&err];
         self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
         Show *show = [self.showResult.shows objectAtIndex:0];
         NSLog(@"0 show name %@", show.name);
         [self.collectionView reloadData];
     }
     ];
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
//    SearchViewController *svc = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:svc animated:YES];
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
    controller.tvdb_id = show.tvdb_id;
    
}
@end
