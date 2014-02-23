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
    UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:@"http://24.media.tumblr.com/2bd8f547fa260c314fba66c079de110f/tumblr_n10vqu2Dql1qkq1vfo1_400.gif"]];
    self.imageView.image = gif;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
