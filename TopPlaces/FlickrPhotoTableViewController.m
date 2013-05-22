//
//  FlickrPhotoTableViewController.m
//  TopPlaces
//
//  Created by Weien Wang on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlickrPhotoTableViewController.h"
#import "PhotoViewerViewController.h"
#import "MapViewController.h"

@interface FlickrPhotoTableViewController() //<MapViewControllerDelegate> future work: implement this for image-in-annotation
@end

@implementation FlickrPhotoTableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //configure cell contents: use photo's title as main label if possible; else use description instead
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    if ([item objectForKey:FLICKR_PHOTO_TITLE] && ![[item objectForKey:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
        cell.textLabel.text = [item objectForKey:FLICKR_PHOTO_TITLE];
        cell.detailTextLabel.text = [item valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];        
    }
    else if ([item valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] && ![[item valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
        cell.textLabel.text = [item valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        cell.detailTextLabel.text = @"";
    }
    else {
        //in this case, set dummy label and subtitle values to prevent reuse of dirty data
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";           
    }
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displayPhoto"]) {
        NSDictionary *item = [self.items objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        [segue.destinationViewController setPhoto:item];
    }
    if ([segue.identifier isEqualToString:@"showPhotoMap"]) {
        [segue.destinationViewController setAnnotations:[self mapAnnotations]];
    }
}


@end
