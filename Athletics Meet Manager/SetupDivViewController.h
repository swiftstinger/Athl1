//
//  SetupDivViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DivAddViewController.h"
#import "Meet.h"
@interface SetupDivViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;


@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;

- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
- (IBAction)importButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;
- (IBAction)exportButtonPressed:(UIBarButtonItem *)sender;

@end
