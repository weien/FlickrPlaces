//
//  FlickrDataViewController.h
//  TopPlaces
//
//  Created by Weien Wang on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"
#import "AnnotationUtil.h"

//basis for other table view controllers, includes basic cell setup, etc.
@interface FlickrDataTableViewController : UITableViewController
- (NSArray*) mapAnnotations;
@property (nonatomic, strong) NSArray* items; //of Flickr dictionaries
@end
