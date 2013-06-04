//
//  MapViewController.m
//  TopPlaces
//
//  Created by Weien Wang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AnnotationUtil.h"

//future work: remove need to reference these classes
#import "FlickrFetcher.h"
#import "PhotoViewerViewController.h"
#import "FlickrPhotoTableViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSArray *items;

@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize mapViewControllerDelegate = _mapViewControllerDelegate;
@synthesize items = _items;

//called if either MapView or Annotations are changed, keeping both in sync
- (void) updateMapView {
    //replace any old annotations
    if (self.mapView.annotations) [self.mapView removeAnnotations:(self.mapView.annotations)];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void) setMapView:(MKMapView *)mapView {
    _mapView = mapView;
    [self updateMapView];
}

- (void) setAnnotations:(NSArray *)annotations {
    _annotations = annotations;
    [self updateMapView];
}

//sets up preview image within annotation for mapView of photos
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; //must set accessoryview here, not in didSelectAnnotationView
        if (self.mapViewControllerDelegate) //check for image delegate before allocating space
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]; //30x30 is good size for an annotation image
    }
    aView.annotation = annotation;
    [(UIImageView*)aView.leftCalloutAccessoryView setImage:nil]; //prevent dirty data use
    return aView;
}

//sent when pin is selected on map; set calloutview image at this point (instead of when pin is generated)
- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
    UIImage *image = [self.mapViewControllerDelegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView*) aView.leftCalloutAccessoryView setImage:image];
}

//initiate segues to phototableview/photoview via map
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    AnnotationUtil *au = view.annotation;
    if ([au.mappedItem valueForKey:@"place_type"]!=nil) //using "place_type" (unique to place-object) to determine which segue to perform
        [self performSegueWithIdentifier:@"showAnnotationPlace" sender:au.mappedItem];
    else
        [self performSegueWithIdentifier:@"showAnnotationPhoto" sender:au.mappedItem];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAnnotationPlace"]) {

        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            FlickrDataTableViewController* dvc = (FlickrDataTableViewController*) segue.destinationViewController;
            NSArray *fetchedItems = [FlickrFetcher photosInPlace:sender maxResults:50];
            dispatch_async(dispatch_get_main_queue(), ^{
                [dvc setItems:fetchedItems];
                [dvc setTitle:[sender objectForKey:@"woe_name"]];
                [dvc.spinner stopAnimating];
            });
        });
    }
    if ([segue.identifier isEqualToString:@"showAnnotationPhoto"]) {
        [segue.destinationViewController setPhoto:sender];
    }
}

//thanks to Jan S. http://stackoverflow.com/a/10645929/2284713
- (void) setInitialVisibleMapRect {
    MKMapRect zoomRect = MKMapRectNull;
    for (AnnotationUtil *anno in self.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(anno.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect))
            zoomRect = pointRect;
        else
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self; //very important; check to make sure nib also reflects this delegate assignment
    [self setInitialVisibleMapRect];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
