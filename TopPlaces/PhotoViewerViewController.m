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
@end

@implementation PhotoViewerViewController
@synthesize scrollView = _scrollView;
@synthesize photoView = _photoView;
@synthesize photo = _photo;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    NSData *photoData = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:_photo format:FlickrPhotoFormatLarge]];
    self.photoView.image = [UIImage imageWithData:photoData];
    self.photoView.frame = CGRectMake(0, 0, self.photoView.image.size.width, self.photoView.image.size.height); //match frame size to image size
    self.scrollView.contentSize = self.photoView.image.size; //set scroll area to entirety of image size, must be set after photoView is set up 
    self.title = [_photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (void) viewWillAppear:(BOOL)animated { //ideal point in lifecycle for performing geometric calculations
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
    [self saveAccessedPhoto];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;
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
