//
//  SearchViewController.m
//  showsApp
//
//  Created by Linkai Xi on 2/5/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "SearchViewController.h"
#import "YQL.h"
//#import "SearchMoviedbResult.h"
//#import "SearchMoviedbModel.h"
#import "Show.h"
#import "ShowResult.h"
#import "SearchCell.h"

@interface SearchViewController ()


//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) UISearchBar *mySearchBar;
@property (nonatomic, strong) ShowResult* searchMoviedbResult;
@property (nonatomic, strong) UIImage* imagePlaceholder;

-(void)reload:(NSString*)searchTxt;
-(NSURL*)buildImageURL:(NSString*)file_path  size:(NSString*)size;


@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//        self.mySearchBar.backgroundColor = [UIColor redColor];

        self.title = @"Search!";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.imagePlaceholder = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://cdn0.iconfinder.com/data/icons/elite-emoticons/512/not-excited-128.png"]]];

    NSLog(@"search view load");
	// Do any additional setup after loading the view.
    //[self reload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchDisplay delegate
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    [self.searchMoviedbResult.shows removeAllObjects];
    [self.collectionView reloadData];
}

- (BOOL) searchDisplayController: (UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return NO;
}

#pragma mark - UISearchBar delegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    NSString* searchText = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [self reload:searchText];
    [self.view endEditing:YES];
    
}

- (void)getSearchResults:(NSString *)searchText startingFrom:(int)start {
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.searchMoviedbResult.shows count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Show *show = self.searchMoviedbResult.shows[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.showsNameLabel setText:show.original_name];
//    UIImage *placeholderImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/skull.png",[self applicationDocumentsDirectory]]];
    [cell.showsPosterImage setImageWithURL:[self buildImageURL:show.poster_path size:@"w185"] placeholderImage:self.imagePlaceholder];
    
    return cell;

}


//- (NSString *)applicationDocumentsDirectory
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    return basePath;
//}

-(NSURL*)buildImageURL:(NSString *)file_path size:(NSString *)size{
    if (file_path==NULL) {
        return NULL;
    }
    static NSString *base_url = @"http://image.tmdb.org/t/p/";
    NSString* baseAndSize = [base_url stringByAppendingString:size];
    NSString* fullString = [baseAndSize stringByAppendingString:file_path];
    return [[NSURL alloc]initWithString:fullString];
}

-(void)reload:(NSString*)searchTxt{
    [[YQL
      use:@{@"store://pgdGby6VuyucfR52SFZ1wb": @"tmdbsearch" }]
      select:@"*" from:@"tmdbsearch" where:@{ @"query" : searchTxt }
      callback:^(NSError *error, id response) {
          //NSLog(@"return reposnse: %@", response);
          NSDictionary *searchJSON = [response valueForKeyPath:@"query.results.json"];
          NSLog(@"%@", searchJSON);
          self.searchMoviedbResult = [[ShowResult alloc]initWithDictionary:searchJSON error:nil];
         // NSLog(@"result %@", self.searchMoviedbResult);
          Show *model = [self.searchMoviedbResult.shows objectAtIndex:0];
         NSLog(@"name is %@", model.name );
          [self.collectionView reloadData];
      }];
    
    
}
@end
