//
//  EnterResultsViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventScoreSheetViewController.h"
#import "Meet.h"
#import "EventResultTableViewCell.h"
#import <CloudKit/CloudKit.h>

@interface EnterResultsViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;
@property (strong, nonatomic) Event* savedEventObject;


@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateOnlineButton;
- (IBAction)updateOnlineButtonPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) NSIndexPath *lastpathselected;
@end
