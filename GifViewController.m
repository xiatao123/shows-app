//
//  GifViewController.m
//  showsApp
//
//  Created by Daniel Park on 2/19/14.
//  Copyright (c) 2014 Shows. All rights reserved.
//

#import "GifViewController.h"
#import "UIImage+animatedGIF.h"

@interface GifViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GifViewController

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
    NSLog(@"VIEW DID LOAD");
    UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://24.media.tumblr.com/6018ca761c8c5dfae87c4c6069d13e24/tumblr_n167hnI75J1srbvdlo1_400.gif"]];
    self.imageView.animationImages = [gif.images subarrayWithRange:NSMakeRange(0, 17)];
    self.imageView.animationDuration = gif.duration;
    self.imageView.animationRepeatCount = 1;
    self.imageView.image = [gif.images objectAtIndex:17];
    [self.imageView startAnimating];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
