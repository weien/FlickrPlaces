//
//  FlickrPlacesTableViewController.m
//  TopPlaces
//
//  Created by Weien Wang on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "MapViewController.h"

@interface FlickrPlacesTableViewController()
@end

@implementation FlickrPlacesTableViewController

- (IBAction)refresh:(id)sender {
    //set up activity indicator
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    }
    //move flickr places download off of main thread
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *fetchedItems = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{ //set self.items on main queue
            self.navigationItem.leftBarButtonItem = sender;
            self.items = fetchedItems;
        });
    });
}

- (void) viewDidLoad {
    [self refresh:self.navigationItem.leftBarButtonItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //cell content configuration
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"woe_name"];
    cell.detailTextLabel.text = [item objectForKey:FLICKR_PLACE_NAME];
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotosForPlace"]) {        
        NSDictionary *item = [self.items objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            FlickrDataTableViewController* dvc = (FlickrDataTableViewController*) segue.destinationViewController;
            NSArray *fetchedItems = [FlickrFetcher photosInPlace:item maxResults:50];
            dispatch_async(dispatch_get_main_queue(), ^{
                [dvc setItems:fetchedItems];
                [dvc setTitle:[item objectForKey:@"woe_name"]];
                [dvc.spinner stopAnimating];
            });
        });
    }
    if ([segue.identifier isEqualToString:@"showCityMap"]) {
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
        //NSLog(@"Here we go: %@", self.items.description);
    }    
}

@end
