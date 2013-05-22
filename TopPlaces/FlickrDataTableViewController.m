//
//  FlickrDataViewController.m
//  TopPlaces
//
//  Created by Weien Wang on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrDataTableViewController.h"

@interface FlickrDataTableViewController ()
@end

@implementation FlickrDataTableViewController
@synthesize items = _items;

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        
        //update table if tableview is up
        if (self.tableView.window) {
            [self.tableView reloadData];
        }
    }
}

- (NSArray*) mapAnnotations {
    NSMutableArray* annotations = [NSMutableArray arrayWithCapacity:[self.items count]];
    //assign annotation for each item
    for (NSDictionary* item in self.items) {
        [annotations addObject:[AnnotationUtil annotationForItem:item]];
    }
    return annotations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Item Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //initialize nil cells
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
