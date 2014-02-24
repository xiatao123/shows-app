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
#import "Episode.h"
#import "UIImageView+AFNetworking.h"
#import "LocalStorage.h"
#import <Parse/Parse.h>
#import "GlobalShows.h"
#import "GlobalMethod.h"
#import <EventKit/EventKit.h>
#import "UIImage+animatedGIF.h"

@interface ShowDetailsViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) Show *show;
@property (strong, nonatomic) Episode *episode;
@property (weak, nonatomic) IBOutlet UILabel *showOverview;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) PFObject *favorite;
@property (assign, nonatomic) bool is_favorited;
- (IBAction)onFavTap:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favButton;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *networksLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)onHomeTap:(id)sender;
@property (strong, nonatomic) NSString* savedEventId;

- (IBAction)onCalendarTap:(id)sender;

- (IBAction)onRightSwipeGesture:(id)sender;
- (IBAction)onLeftSwipeGesture:(id)sender;
- (void)addCalendarEvent;
- (void)removeCalendarEvent;

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
    self.scrollView.contentSize = CGSizeMake(320, 1300);
    //[self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.layer.zPosition = 1;
    // self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    
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
    
    /*
    [[YQL use:@{@"https://raw.github.com/ios-class/yshows-tables/master/tmdb.tv.id.xml": @"identity" }] select:@"*" from:@"identity" where:@{ @"id" : self.tmdb_id } callback:^(NSError *error, id response) {
        
        NSObject *results = [response valueForKeyPath:@"query.results.json"];
        NSLog(@"%@", results);
        self.showOverview.text = [results valueForKey:@"overview"];
    }];
    */
    
    if (self.show.details) {
        NSLog(@"SHOW ID IS %@", self.show.id);
        self.showOverview.text = self.show.overview;
        self.createdByLabel.text = self.show.created_by;
        self.runTimeLabel.text = self.show.runtimes;
        self.genreLabel.text = self.show.genres;
        self.networksLabel.text = self.show.networks;
        self.statusLabel.text = self.show.status;
        self.castLabel.text = self.show.cast;
        
        if (self.show.has_gif) {
            if (self.show.gif_loop) {
                self.showImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:self.show.gif_url]];
                self.show.gif_loop = YES;
            }
            else {
                UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:self.show.gif_url]];
                self.showImage.animationImages = [gif.images subarrayWithRange:NSMakeRange(0, self.show.gif_end)];
                self.showImage.animationDuration = gif.duration;
                self.showImage.animationRepeatCount = 1;
                self.showImage.image = [gif.images objectAtIndex:self.show.gif_end];
                [self.showImage startAnimating];
            }
        }
        else {
            NSString *backdrop_url = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500/%@", [self.show valueForKey:@"backdrop_path"]];
            [self.showImage setImageWithURL:[NSURL URLWithString:backdrop_url]];
        }
    }
    else [[YQL use:@{@"https://raw.github.com/ios-class/yshows-tables/master/tmdb.tv.id.xml": @"identity",
              @"https://raw2.github.com/ios-class/yshows-tables/master/tmdb.tv.credits.xml": @"credits"}]
          query:[NSString stringWithFormat:@"select * from yql.query.multi where queries='select * from identity where id=%@; select * from credits where id=%@; select feed.entry from json where url=\"https://spreadsheets.google.com/feeds/list/0Asp5x6yM0pSXdFM3UTEta1lHelJsZGRXMW1uVzNDSVE/od6/public/values?alt=json\" and feed.entry.gsx_id._t=%@'", self.tmdb_id, self.tmdb_id, self.tmdb_id]
          callback:^(NSError * error, id response) {
              //NSLog(@"got response %@", response);
              NSArray *results = [response valueForKeyPath:@"query.results.results"];
              NSObject *info = [results objectAtIndex:0];
              NSObject *crew = [results objectAtIndex:1];
              NSObject *gif = [results objectAtIndex:2];
              if (info) {
                  self.show.overview = self.showOverview.text = [info valueForKeyPath:@"json.overview"];
                  // self.runTimeLabel.text = [info valueForKeyPath:@"json.runtime"];
                  self.show.created_by = self.createdByLabel.text = [[((NSArray*)[info valueForKeyPath:@"json.created_by"]) valueForKey:@"name"] componentsJoinedByString:@", "];
                  self.show.runtimes = self.runTimeLabel.text = [((NSArray*)[info valueForKeyPath:@"json.episode_run_time"])  componentsJoinedByString:@", "];
                  self.show.genres = self.genreLabel.text = [[((NSArray*)[info valueForKeyPath:@"json.genres"]) valueForKey:@"name"] componentsJoinedByString:@", "];
                  self.show.networks = self.networksLabel.text = [[((NSArray*)[info valueForKeyPath:@"json.networks"]) valueForKey:@"name"] componentsJoinedByString:@", "];
                  self.show.status = self.statusLabel.text = [info valueForKeyPath:@"json.status"];
                  
              }
              if (crew) {
                  //NSLog(@"crew is %@", crew);
                  NSMutableArray *cast = [[NSMutableArray alloc] init];
                  for (NSObject *person in (NSArray*)[crew valueForKeyPath:@"json.cast"]) {
                      [cast addObject:[person valueForKey:@"name"]];
                  }
                  self.show.cast = self.castLabel.text = [cast componentsJoinedByString:@", "];
                  [self.castLabel sizeToFit];
              }
              if (![[gif description] isEqualToString:@"<null>"]) {
                  NSLog(@"VALUE OF GIF IS %@", gif);
                  self.show.has_gif = YES;
                  self.show.gif_url = [gif valueForKeyPath:@"json.feed.entry.gsx_src._t"];
                  self.show.gif_end = [[gif valueForKeyPath:@"json.feed.entry.gsx_cut._t"] intValue];
                  NSLog(@"got gif %@", gif);
                  
                  
                  if (self.show.gif_end == 0) {
                      self.showImage.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:self.show.gif_url]];
                      self.show.gif_loop = YES;
                  }
                  else {
                      UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:self.show.gif_url]];
                      self.showImage.animationImages = [gif.images subarrayWithRange:NSMakeRange(0, self.show.gif_end)];
                      self.showImage.animationDuration = gif.duration;
                      self.showImage.animationRepeatCount = 1;
                      self.showImage.image = [gif.images objectAtIndex:self.show.gif_end];
                      [self.showImage startAnimating];
                  }
              }
              
              else {
                 NSString *backdrop_url = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500/%@", [self.show valueForKey:@"backdrop_path"]];
                  [self.showImage setImageWithURL:[NSURL URLWithString:backdrop_url]];
              }
              self.show.details = YES;
              [[GlobalShows globalShowsSingleton] setValue:self.show forKey:self.show.id];
          }
    ];
    
    NSString *guid = [(NSDictionary *)[LocalStorage read:@"current_user"] objectForKey:@"guid"];
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"guid" equalTo:guid];
    [query whereKey:@"tmdb_id" equalTo:self.tmdb_id];
    [self.favButton setEnabled:NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            //NSLog(@"got objects %d", [objects count]);
        if ([objects count] == 1) {
            self.favorite = [objects objectAtIndex:0];
                //self.favButton.title = @"Unfavorite";
            self.favButton.image = [UIImage imageNamed:@"fav_active"];
            self.is_favorited = true;
        }
        [self.favButton setEnabled:YES];
    }];
    
    NSString* x = [NSString stringWithFormat: @"use 'store://6p3MRsP6JUlzV5obpwzSXJ' as table; select * from table where seriesname='%@' and date='%@';", self.show.name, [GlobalMethod buildTodayDateFormat]];
                   
    
    NSLog(@"%@", x);
    [YQL query:[NSString stringWithFormat: @"use 'store://6p3MRsP6JUlzV5obpwzSXJ' as table; select * from table where seriesname='%@' and date='%@';", self.show.name, [GlobalMethod buildTodayDateFormat]]
      callback:^(NSError *error, id response) {
          NSDictionary *showJSON = [response valueForKeyPath:@"query.results.Episode"] ;
          NSError *err = nil;
          self.episode = [[Episode alloc]initWithDictionary:showJSON error:&err];
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
                //self.favButton.title = @"Favorite";
            self.favButton.image = [UIImage imageNamed:@"fav_down"];
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
                //self.favButton.title = @"Unfavorite";
            self.favButton.image = [UIImage imageNamed:@"fav_active"];
            [self.favButton setEnabled:YES];
            
        }];
    }
}

-(void)removeCalendarEvent{
    EKEventStore* store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        NSLog(@"remove calendar event");
        EKEvent* eventToRemove = [store eventWithIdentifier:self.savedEventId];
        if (eventToRemove) {
            NSError* error = nil;
            [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
        }
    }];
}

-(void)addCalendarEvent{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        NSLog(@"add calender event");
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = self.show.name;
        //self.episode.Airs_Time
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        event.startDate = [dateFormat dateFromString:self.episode.FirstAired];
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        //event.allDay = YES;
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        self.savedEventId = event.eventIdentifier;  //this is so you can access this event later
    }];

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

- (IBAction)onHomeTap:(id)sender {
    NSLog(@"home tap!");
}

- (IBAction)onCalendarTap:(id)sender {
    UIAlertView *alert;
    if (self.episode != NULL) {
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"Show is on %@", self.episode.FirstAired]
                                     message:@"Do you want to add notification on your calendar?"
                                        delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:@"NO", nil];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:@"Show is ended"
                                     message:@"Get Resources from the Internet!"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
    }
     [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.cancelButtonIndex ){
        [self addCalendarEvent];
    }else{
        
    }
}

- (IBAction)onRightSwipeGesture:(id)sender {
        //NSLog(@"swipe right!");
    int index = 0;
    NSArray* keyBucket = [[GlobalShows globalTriageBucket]objectForKey:self.bucketKey];
    for(NSString* showIDString in keyBucket){
        if(showIDString == self.tmdb_id){
            if (index > 0) {
                NSString* prevShowIDString = [keyBucket objectAtIndex:(index-1)];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ShowDetailsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];
                    //[self.navigationController pushViewController:svc animated:YES];
                [UIView animateWithDuration:0.75
                                 animations:^{
                                     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                     [self.navigationController pushViewController:svc animated:NO];
                                     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
                                 }];

                Show* nextShow = [[GlobalShows globalShowsSingleton] objectForKey:prevShowIDString];
                svc.tmdb_id = nextShow.id;
                svc.bucketKey = self.bucketKey;
                [self hackBackAfterSwipe];
            }
            break;
        }
        index++;
    }
}

- (IBAction)onLeftSwipeGesture:(id)sender {
        //NSLog(@"swipe left!");
    int index = 0;
    NSArray* keyBucket = [[GlobalShows globalTriageBucket]objectForKey:self.bucketKey];
    for(NSString* showIDString in keyBucket){
        if(showIDString == self.tmdb_id){
            if( (index + 1) < keyBucket.count ){
                NSString* nextShowIDString = [keyBucket objectAtIndex:(index+1)];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ShowDetailsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"ShowDetailsViewController"];

                [UIView animateWithDuration:0.75
                                 animations:^{
                                     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                                     [self.navigationController pushViewController:svc animated:NO];
                                     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                                 }];
                
                Show* nextShow = [[GlobalShows globalShowsSingleton] objectForKey:nextShowIDString];
                svc.tmdb_id = nextShow.id;
                svc.bucketKey = self.bucketKey;
                [self hackBackAfterSwipe];
            }
            break;
        }
        index++;
    }

}

-(void)hackBackAfterSwipe{
    NSMutableArray *VCs = [self.navigationController.viewControllers mutableCopy];
    [VCs removeObjectAtIndex:[VCs count] - 2];
    self.navigationController.viewControllers = VCs;
}
@end
