//
//  EventScoreSheetViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventScoreAddViewController.h"
#import "Event.h"


@interface EventScoreSheetViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Event* eventObject;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender;


- (IBAction)addCEventScore:(UIBarButtonItem *)sender;


- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;

@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;

@end
