//
//  MasterViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MeetAddViewController.h"
//#import "MeetViewController.h"

//@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;

- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (void)setOnlineMeet:(NSString *)meetOnlineID;

@end

