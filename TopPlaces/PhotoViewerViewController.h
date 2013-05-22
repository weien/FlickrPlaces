//
//  PhotoViewer.h
//  TopPlaces
//
//  Created by Weien Wang on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface PhotoViewerViewController : UIViewController
@property (assign, nonatomic) NSDictionary* photo;
@end
