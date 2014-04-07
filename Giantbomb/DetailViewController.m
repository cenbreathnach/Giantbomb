//
//  DetailViewController.m
//  Giantbomb
//
//  Created by Cionnat Breathnach on 28/03/2014.
//  Copyright (c) 2014 Cionnat Breathnach. All rights reserved.
//
//video api call for game
//http://www.giantbomb.com/api/video/8367/?api_key=db83ace1ea2b58b18cbf4ac7696df4a5508120c6&format=json

#import "DetailViewController.h"
#import "VideosTableViewController.h"
#import "AFNetworking.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}



- (void)setGameInfo:(NSDictionary *)newInfo
//-(void) setGameInfoArray:(NSMutableArray *)newInfo
{
    if (_gameInfo != newInfo) {
        _gameInfo = newInfo;
        // Update the view.
            [self.scroller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    [self configureView];

}

-(NSString *) stringByStrippingHTML:(NSString *)htmlString {
    NSRange r;
    NSString *s = [htmlString copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    //NSLog(@"%@", s);
    return s;
}


- (void)configureView
{
    if(self.gameInfo) {
        for (UIView *subView in self.view.subviews)
        {
            if (subView.tag == 99)
            {
                [subView removeFromSuperview]; //remove background image
            }
        }
      
        self.navigationItem.title = [self.gameInfo objectForKey:@"name"];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:.5]];

        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor redColor]];

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        NSDictionary *dict = [self.gameInfo objectForKey:@"image"];
        NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:@"small_url"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake((screenWidth/2)-(image.size.width/2), 20, image.size.width, image.size.height)];
        imageView.image = image;
        [self.scroller addSubview:imageView];
        
        //about game
        NSString *aboutGame=[self stringByStrippingHTML:[self.gameInfo objectForKey:@"deck"]];
        UILabel *aboutGameLabel =[[UILabel alloc] initWithFrame:CGRectMake(20,(image.size.height+40), 663, 663)];
        
        
        CGSize maximumAboutGameLabelSize = CGSizeMake(663, 9999);
        CGSize expectedAboutGameLabelSize = [aboutGame sizeWithFont:aboutGameLabel.font
                                               constrainedToSize:maximumAboutGameLabelSize
                                                   lineBreakMode:aboutGameLabel.lineBreakMode];
        CGRect newAboutGameFrame = aboutGameLabel.frame;
        newAboutGameFrame.size.height = expectedAboutGameLabelSize.height;
        aboutGameLabel.frame = newAboutGameFrame;

        aboutGameLabel.text = aboutGame;
        aboutGameLabel.textColor = [UIColor whiteColor];
        aboutGameLabel.numberOfLines = 0; //will wrap text in new line
        [aboutGameLabel sizeToFit];
        
        [self.scroller addSubview:aboutGameLabel];
        //end about game
        //gamedescription
        NSString *gameDescription=[self stringByStrippingHTML:[self.gameInfo objectForKey:@"description"]];
        UILabel *gameDescriptionLabel =[[UILabel alloc] initWithFrame:CGRectMake(20,(image.size.height+40 +aboutGameLabel.frame.size.height +40), 663, 663)];
        
        CGSize maximumLabelSize = CGSizeMake(663, 9999);
        CGSize expectedLabelSize = [gameDescription sizeWithFont:gameDescriptionLabel.font
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:gameDescriptionLabel.lineBreakMode];
        CGRect newFrame = gameDescriptionLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        gameDescriptionLabel.frame = newFrame;
        
        
        
        gameDescriptionLabel.text = gameDescription;
        gameDescriptionLabel.textColor = [UIColor whiteColor];
        [gameDescriptionLabel setTextAlignment:NSTextAlignmentLeft];
        gameDescriptionLabel.numberOfLines = 0; //will wrap text in new line
        [gameDescriptionLabel sizeToFit];
        
        [self.scroller addSubview:gameDescriptionLabel];
        
        
        NSDictionary *videos = [self.gameInfo objectForKey:@"videos"];
       // NSLog(@"%@", videos);
        if([videos count]){
            NSLog(@"%@", videos);
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
        }
        else {
            self.navigationItem.rightBarButtonItem.enabled = NO;

        }
        
        CGRect contentRect = CGRectZero;
        for (UIView *view in self.scroller.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        self.scroller.contentSize = contentRect.size;
    }
   else{
       
       self.navigationItem.rightBarButtonItem.enabled = NO;

       [self setBackgroundImage:@"background.png"];
   }
    
}

-(void) setBackgroundImage:(NSString *)imageName{
    UIImage *backgroundImage = [UIImage imageNamed:imageName];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    backgroundImageView.tag = 99;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.navigationItem.title = [self.gameInfo objectForKey:@"name"];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor redColor]];

    [self.view setBackgroundColor:[UIColor colorWithRed:(51/255.0) green:(51/255.0) blue:(51/255.0) alpha:1]];
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(703, 1200)];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{    
    barButtonItem.title = NSLocalizedString(@"Search", @"Search");
   [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
     self.masterPopoverController = popoverController;
    [self configureView];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"videoPopover"])
    {
        VideosTableViewController *controller = (VideosTableViewController *)segue.destinationViewController;
        [controller setVideoArray:[self.gameInfo objectForKey:@"videos"]];
    }
}

@end
