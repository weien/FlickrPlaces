//
//  PhotoViewer.m
//  TopPlaces
//
//  Created by Weien Wang on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewerViewController.h"

@interface PhotoViewerViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation PhotoViewerViewController
@synthesize scrollView = _scrollView;
@synthesize photoView = _photoView;
@synthesize photo = _photo;

#pragma mark Utilities

- (void) saveAccessedPhoto {
    NSUserDefaults *recentPhotoDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedPhotos = [[recentPhotoDefaults objectForKey:@"recents"] mutableCopy];
    if (!savedPhotos) savedPhotos = [NSMutableArray array]; //initial instantiation if "recents" array doesn't exist
    NSMutableArray *filteredPhotos = [savedPhotos mutableCopy];
    
    for (id element in savedPhotos) {
        if ([element objectForKey:FLICKR_PHOTO_ID] == [_photo objectForKey:FLICKR_PHOTO_ID])
            [filteredPhotos removeObject:element]; //don't want same photo twice in the recent photos list
    }
    [filteredPhotos addObject:self.photo];
    [recentPhotoDefaults setObject:[filteredPhotos copy] forKey:@"recents"];
    [recentPhotoDefaults synchronize];
}

- (void) initSpinner {
    if (!self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:self.spinner];
        self.spinner.center = self.view.center;
        //self.spinner.backgroundColor = [UIColor blackColor];
        self.spinner.hidesWhenStopped = YES;
        [self.spinner startAnimating];
    }
}

- (void) setZoomBasedOnImageDimensions {
    float imageWidth = self.photoView.image.size.width;
    float imageHeight = self.photoView.image.size.height;
    float scrollWidth = self.scrollView.frame.size.width;
    float scrollHeight = self.scrollView.frame.size.height;
    
    //future work: adjust calculation for landscape view
    if (imageWidth >= imageHeight) {
        [self.scrollView setZoomScale:(scrollHeight/imageHeight)];
    }
    else {
        [self.scrollView setZoomScale:(scrollWidth/imageWidth)];
    }
}

#pragma mark UIScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSpinner];
    self.scrollView.delegate = self;
    NSURL *fetchedURL = [FlickrFetcher urlForPhoto:_photo format:FlickrPhotoFormatLarge];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *photoData = [NSData dataWithContentsOfURL:fetchedURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoView.image = [UIImage imageWithData:photoData];
            
            //order of following is very important; thanks to m2m @ http://cs193p.m2m.at/cs193p-assignment-5-task-1/#more-2064
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = self.photoView.image.size; //must be set after photoView image is set
            
            self.photoView.frame = CGRectMake(0, 0, self.photoView.image.size.width, self.photoView.image.size.height); //match frame size to image size after scroll view is set
            
            [self setZoomBasedOnImageDimensions];
            [self.spinner stopAnimating];
        });
    });
    self.title = [_photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (void) viewWillAppear:(BOOL)animated {
    //this is a good point in lifecycle to perform geometric calculations like zoomscale
    [self setZoomBasedOnImageDimensions];
    [self saveAccessedPhoto];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidUnload
{    
    //release any retained subviews of the main view
    [self setPhotoView:nil];
    [self setScrollView:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
