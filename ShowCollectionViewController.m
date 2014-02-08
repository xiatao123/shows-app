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
#import "UIImageView+AFNetworking.h"

@interface ShowCollectionViewController ()

-(void)reload;

@property (nonatomic, strong) ShowResult* showResult;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

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
    NSLog(@"title is %@", show.title);
    cell.backgroundColor = [UIColor whiteColor];
    [cell.showsNameLabel setText:show.title];
    [cell.showsPosterImage setImageWithURL:show.poster];

    return cell;
}

-(void)reload{
    [[YQL
      use:@{@"store://lsri0aFyNSXQsSFK0jYL9F": @"tvdb" }]
      select:@"*"
      from:@"tvdb"
      where:@{ @"date" : @"20140114" }
      callback:^(NSError *error, id response) {
         
         //NSLog(@"got resposne %@", response);
         // NSLog(@"get response.result %@", [response valueForKeyPath:@"query.results.results"] );
         NSDictionary *showJSON = [response valueForKeyPath:@"query.results.results"] ;
         NSError *err = nil;
         //NSLog(@"%@",showJSON);
         //Show *show = [[Show alloc]initWithDictionary:showJSON error:&err];
         self.showResult = [[ShowResult alloc] initWithDictionary:showJSON error:&err];
         Show *show = [self.showResult.shows objectAtIndex:0];
         NSLog(@"0 show name %@", show.title);
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
@end
