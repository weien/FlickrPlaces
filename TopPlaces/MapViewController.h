//
//  MapViewController.h
//  TopPlaces
//
//  Created by Weien Wang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

//future work: implement this delegate in FlickrPhotoTableViewController for images in annotation callouts
//obviates need for this class to be aware of Flickr interface
@protocol MapViewControllerDelegate <NSObject>
- (UIImage*)mapViewController:(MapViewController*) sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

//displays MapView
@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray* annotations; //array of <MKAnnotation>s
@property (nonatomic, weak) id <MapViewControllerDelegate> mapViewControllerDelegate;
@end
