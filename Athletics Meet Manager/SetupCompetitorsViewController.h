//
//  SetupCompetitorsViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CompetitorAddViewController.h"
#import "Team.h"

@interface SetupCompetitorsViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Team* teamObject;
- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;


@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
- (IBAction)importButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;
- (IBAction)exportButtonPressed:(UIBarButtonItem *)sender;

@end
