//
//  FlickrRecentTableViewController.m
//  TopPlaces
//
//  Created by Weien Wang on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrRecentTableViewController.h"

@implementation FlickrRecentTableViewController

- (void) viewWillAppear:(BOOL)animated {
    //update self.items with contents of NSUserDefaults array
    NSUserDefaults *recentPhotoDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotos = [[[recentPhotoDefaults objectForKey:@"recents"] reverseObjectEnumerator] allObjects];
    self.items = recentPhotos;
    [self.tableView reloadData];
}

- (IBAction)clearRecents:(id)sender {
    NSUserDefaults *recentPhotoDefaults = [NSUserDefaults standardUserDefaults];
    //loop through NSUserDefaults, blow away keyed objects
    for (NSString *key in [[recentPhotoDefaults dictionaryRepresentation] allKeys]) {
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [self viewWillAppear:FALSE];
}

@end
