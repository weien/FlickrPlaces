//
//  AnnotationUtil.h
//  TopPlaces
//
//  Created by Weien Wang on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//sets up annotations for MapView
@interface AnnotationUtil : NSObject <MKAnnotation> //protocol for common annotation attributes (title, subtitle, coordinate)
@property (nonatomic, strong) NSDictionary* mappedItem;
+ (AnnotationUtil *) annotationForItem:(NSDictionary *) item;
@end
