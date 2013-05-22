//
//  AnnotationUtil.m
//  TopPlaces
//
//  Created by Weien Wang on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnnotationUtil.h"
#import "FlickrFetcher.h"

@implementation AnnotationUtil
@synthesize mappedItem = _mappedItem;

+ (AnnotationUtil*) annotationForItem:(NSDictionary *)item { 
    //convenience method to assign an annotation for each item
    AnnotationUtil *annotation = [[AnnotationUtil alloc] init];
    annotation.mappedItem = item;
    return annotation;
}

- (NSString*) title {
    //if available, mappedItem is a place, set WhereOnEarth name as Title; if not, mappedItem is a photo
    if ([self.mappedItem objectForKey:@"woe_name"])
        return [self.mappedItem objectForKey:@"woe_name"];
    else
        return [self.mappedItem objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString*) subtitle {
    if ([self.mappedItem valueForKeyPath:FLICKR_PLACE_NAME])
        return [self.mappedItem valueForKeyPath:FLICKR_PLACE_NAME];
    else
        return [self.mappedItem valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.mappedItem objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.mappedItem objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
