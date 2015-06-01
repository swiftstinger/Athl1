//
//  MasterViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MeetAddViewController.h"
//#import "MeetViewController.h"

//@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,MeetAddViewControllerDelegate>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;

@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;

@end

